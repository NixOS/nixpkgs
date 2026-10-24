{
  bash,
  coreutils,
  cudaPackages,
  lib,
  pycuda,
  python,
  runCommand,
}:
let
  pythonEnv = python.withPackages (_: [ pycuda ]);
  arch = lib.replaceStrings [ "." ] [ "" ] (lib.head cudaPackages.cudaConfig.cudaCapabilities);
in
runCommand "${pycuda.name}-jit" { } ''
  mkdir -p "$out"
  # Loading PyCUDA's extension needs libcuda, but compiling with an explicit
  # architecture does not need a GPU or a driver context. Use the SDK stub.
  env -i HOME="$TMPDIR" TMPDIR="$TMPDIR" \
    PATH=${
      lib.makeBinPath [
        coreutils
        bash
      ]
    } \
    LD_LIBRARY_PATH=${lib.getOutput cudaPackages.cuda_cudart.outputStubs cudaPackages.cuda_cudart}/lib/stubs \
    ${pythonEnv.interpreter} - "$out" <<'PYTHON'
  from pathlib import Path
  import shutil
  import sys
  from pycuda.compiler import compile

  assert shutil.which("nvcc") is None
  source = """
  #include <curand_kernel.h>
  #include <cuda/std/type_traits>
  extern "C" __global__ void saxpy(int n, float a, const float *x, float *y) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) y[i] = a * x[i] + y[i];
  }
  """
  for target in ("ptx", "cubin"):
      data = compile(source, arch="sm_${arch}", target=target, no_extern_c=True)
      assert data
      Path(sys.argv[1], "saxpy." + target).write_bytes(data)
  assert list(Path.home().glob(".cache/pycuda/compiler-cache-v1/*"))
  PYTHON
''
