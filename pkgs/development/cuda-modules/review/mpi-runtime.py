"""Check installed HOST MPI wrappers and local collectives without a setup hook.

Run on the HOST with rebuild.nix's metadata JSON. Requires a GPU for the
single-PE NVSHMEM example; this is not a multi-node or RDMA test.
"""

import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
import tempfile


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--metadata", type=Path, required=True)
parser.add_argument("--driver-library-path", required=True)
parser.add_argument("--cuda-include", type=Path, required=True)
parser.add_argument("--skip-nvshmem", action="store_true")
args = parser.parse_args()
metadata = json.loads(args.metadata.read_text())


def executable(package, name):
    paths = [Path(output) / "bin" / name for output in metadata[package]["outputs"].values()]
    return str(next(path for path in paths if path.is_file()))


with tempfile.TemporaryDirectory(prefix="mpi-runtime-") as tmp:
    directory = Path(tmp)
    env = {
        "HOME": tmp,
        "TMPDIR": tmp,
        "PATH": "/run/current-system/sw/bin",
        "LC_ALL": "C",
        "LD_LIBRARY_PATH": args.driver_library_path,
        "OMP_NUM_THREADS": "2",
        "OPENBLAS_NUM_THREADS": "2",
    }
    results = []

    def run(command, **kwargs):
        result = subprocess.run(
            command, env=env, cwd=directory, text=True, encoding="utf-8",
            errors="backslashreplace", capture_output=True, timeout=120, **kwargs
        )
        record = dict(command=command, exit=result.returncode, stdout=result.stdout, stderr=result.stderr)
        results.append(record)
        print(json.dumps(record), flush=True)
        result.check_returncode()
        return result.stdout

    c_source = """#include <mpi.h>
#include <stdio.h>
int main(void) {
    int major, minor;
    if (MPI_Get_version(&major, &minor) != MPI_SUCCESS || major < 3) return 1;
    printf("MPI %d.%d\\n", major, minor);
    return 0;
}
"""
    for wrapper, extension in (("mpicc", "c"), ("mpicxx", "cpp")):
        compiler = shlex.split(run([executable("mpi", wrapper), "--showme:command"]))
        assert compiler and os.path.isabs(compiler[0]), compiler
        run([*compiler, "-dumpmachine"])
        source = directory / ("version." + extension)
        source.write_text(c_source)
        output = directory / wrapper
        run([executable("mpi", wrapper), str(source), "-o", str(output)])
        run([str(output)])

    compiler = shlex.split(run([executable("mpi", "mpifort"), "--showme:command"]))
    assert compiler and os.path.isabs(compiler[0]), compiler
    run([*compiler, "-dumpmachine"])
    source = directory / "collective.f90"
    source.write_text("""program collective
  use mpi_f08
  use, intrinsic :: ieee_arithmetic, only: ieee_is_finite
  implicit none
  integer :: ierr, rank, count, sent, received, bytes
  logical :: logical_sent, logical_received
  real(kind=16) :: real_sent, real_received, expected
  call MPI_Init(ierr)
  if (ierr /= MPI_SUCCESS) stop 1
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  if (ierr /= MPI_SUCCESS) stop 2
  call MPI_Comm_size(MPI_COMM_WORLD, count, ierr)
  if (ierr /= MPI_SUCCESS) stop 3
  sent = rank + 1
  call MPI_Allreduce(sent, received, 1, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD, ierr)
  if (ierr /= MPI_SUCCESS .or. received /= count * (count + 1) / 2) stop 4
  call MPI_Type_size(MPI_LOGICAL, bytes, ierr)
  if (ierr /= MPI_SUCCESS .or. bytes /= storage_size(logical_sent) / 8) stop 5
  logical_sent = rank == 0
  call MPI_Allreduce(logical_sent, logical_received, 1, MPI_LOGICAL, MPI_LOR, MPI_COMM_WORLD, ierr)
  if (ierr /= MPI_SUCCESS .or. .not. logical_received) stop 6
  call MPI_Type_size(MPI_REAL16, bytes, ierr)
  if (ierr /= MPI_SUCCESS .or. bytes /= storage_size(real_sent) / 8) stop 7
  real_sent = real(rank + 1, kind=16) / 11.0_16
  call MPI_Allreduce(real_sent, real_received, 1, MPI_REAL16, MPI_SUM, MPI_COMM_WORLD, ierr)
  expected = real(count * (count + 1) / 2, kind=16) / 11.0_16
  if (ierr /= MPI_SUCCESS .or. .not. ieee_is_finite(real_received)) stop 8
  if (abs(real_received - expected) > 1.0e-30_16) stop 8
  call MPI_Finalize(ierr)
  if (ierr /= MPI_SUCCESS) stop 9
  print *, 'MPI_F08 integer/logical/REAL16 collectives passed', rank, count
end program
""")
    output = directory / "collective"
    run([executable("mpi", "mpifort"), str(source), "-o", str(output)])
    run([str(output)])
    run([executable("mpi", "mpirun"), "--oversubscribe", "-n", "2",
         "--mca", "pml", "ob1", "--mca", "btl", "self,sm", str(output)])

    # CUDA headers are needed only by this consumer; MPI's installed plugin
    # must supply its own runtime link to the real driver, without stub RPATHs.
    source = directory / "device-buffers.c"
    source.write_text("""#include <mpi.h>
#include <mpi-ext.h>
#include <cuda.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#define CUDA(call) do { CUresult e = (call); if (e != CUDA_SUCCESS) { \
    fprintf(stderr, "%s: CUDA error %d\\n", #call, (int)e); exit(2); } } while (0)
#define MPI(call) do { if ((call) != MPI_SUCCESS) MPI_Abort(MPI_COMM_WORLD, 3); } while (0)
int main(int argc, char **argv) {
    CUDA(cuInit(0));
    CUdevice device;
    CUcontext context;
    CUDA(cuDeviceGet(&device, 0));
    CUDA(cuDevicePrimaryCtxRetain(&context, device));
    CUDA(cuCtxSetCurrent(context));
    MPI(MPI_Init(&argc, &argv));
    if (!MPIX_Query_cuda_support()) MPI_Abort(MPI_COMM_WORLD, 4);
    int rank, count;
    MPI(MPI_Comm_rank(MPI_COMM_WORLD, &rank));
    MPI(MPI_Comm_size(MPI_COMM_WORLD, &count));
    CUdeviceptr sent, received;
    int host_sent[32], host_received[32];
    for (int i = 0; i < 32; ++i) host_sent[i] = rank * 100 + i;
    CUDA(cuMemAlloc(&sent, sizeof(host_sent)));
    CUDA(cuMemAlloc(&received, sizeof(host_received)));
    CUDA(cuMemcpyHtoD(sent, host_sent, sizeof(host_sent)));
    MPI(MPI_Sendrecv((void *)(uintptr_t)sent, 32, MPI_INT, (rank + 1) % count, 7,
                    (void *)(uintptr_t)received, 32, MPI_INT, (rank + count - 1) % count, 7,
                    MPI_COMM_WORLD, MPI_STATUS_IGNORE));
    CUDA(cuMemcpyDtoH(host_received, received, sizeof(host_received)));
    for (int i = 0; i < 32; ++i)
        if (host_received[i] != ((rank + count - 1) % count) * 100 + i)
            MPI_Abort(MPI_COMM_WORLD, 5);
    CUDA(cuMemFree(sent));
    CUDA(cuMemFree(received));
    printf("CUDA-aware MPI device-buffer exchange passed: rank %d of %d\\n", rank, count);
    MPI(MPI_Finalize());
    CUDA(cuDevicePrimaryCtxRelease(device));
    return 0;
}
""")
    output = directory / "device-buffers"
    run([executable("mpi", "mpicc"), str(source), "-I" + str(args.cuda_include),
         str(Path(args.driver_library_path) / "libcuda.so.1"), "-o", str(output)])
    env["OMPI_MCA_accelerator"] = "cuda"
    run([str(output)])
    run([executable("mpi", "mpirun"), "--oversubscribe", "-n", "2",
         "--mca", "pml", "ob1", "--mca", "btl", "self,smcuda", str(output)])
    # Exercise the existing tmpfs-backed mmap option too. CUDA host registration
    # can reject file-backed mappings on filesystems such as ZFS. Neither run
    # disables CUDA IPC; these 128-byte messages do not prove an IPC data path.
    run([executable("mpi", "mpirun"), "--oversubscribe", "-n", "2",
         "--mca", "pml", "ob1", "--mca", "btl", "self,smcuda",
         "--mca", "shmem_mmap_relocate_backing_file", "1", str(output)])
    if not args.skip_nvshmem:
        env.update(NVSHMEM_REMOTE_TRANSPORT="none", NVSHMEM_BOOTSTRAP="MPI")
        output = run([executable("nvshmem", "examples/dev-guide-ring-mpi")])
        assert [line for line in output.splitlines() if "received message" in line] == [
            "0: received message 0"
        ], output
    print(json.dumps(dict(passed=True, mpi=metadata["mpi"],
                          nvshmem=None if args.skip_nvshmem else metadata["nvshmem"],
                          checks=len(results))))
