{
  buildRedist,
  config,
  lib,
  openssl,
  stdenv,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_compat";

  # NOTE: Using multiple outputs with symlinks causes build cycles.
  # To avoid that (and troubleshooting why), we just use a single output.
  outputs = [ "out" ];

  # libnvidia-pkcs11{-openssl3}.so is only shipped on x86_64-linux
  buildInputs = lib.optionals stdenv.hostPlatform.isx86_64 [
    openssl
  ];

  # As in nvidia-x11, keep the OpenSSL 3 PKCS#11 module and discard the unused
  # alternative linked against OpenSSL 1.1.
  postPatch = ''
    rm -f compat/libnvidia-pkcs11.so*
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libnvdla_runtime.so"
    "libnvrm_gpu.so"
    "libnvrm_mem.so"
  ];

  meta = {
    description = "Provides minor version forward compatibility for the CUDA runtime";
    homepage = "https://docs.nvidia.com/deploy/cuda-compatibility";
    problems = lib.optionalAttrs (!config.enableCudaDriverCompat) {
      cuda-compat-disabled = {
        kind = "broken";
        message = "cuda_compat must be explicitly enabled using config.enableCudaDriverCompat.";
      };
    };
  };
}
