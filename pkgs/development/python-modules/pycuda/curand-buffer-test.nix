{
  cudaPackages,
  lib,
  pycuda,
  python,
  runCommand,
}:
let
  pythonEnv = python.withPackages (_: [ pycuda ]);
in
runCommand "${pycuda.name}-curand-buffers" { } ''
  # cuRAND's host tables need no GPU context. The stub only satisfies the
  # installed PyCUDA extension's dependency on libcuda at import time.
  env -i HOME="$TMPDIR" \
    LD_LIBRARY_PATH=${lib.getOutput cudaPackages.cuda_cudart.outputStubs cudaPackages.cuda_cudart}/lib/stubs \
    OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 \
    ${pythonEnv.interpreter} ${./curand-buffer-test.py} > "$out"
''
