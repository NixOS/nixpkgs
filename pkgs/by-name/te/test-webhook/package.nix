{
  lib,
  runCommand,
  magma,
  cudaSupport,
}:
runCommand "test-webhook"
  {
    buildInputs = lib.optional cudaSupport magma;
  }
  ''
    exit 1
  ''
