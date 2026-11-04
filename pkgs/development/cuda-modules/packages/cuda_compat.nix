{
  buildRedist,
  config,
  lib,
  manifests,
  openssl,
  stdenv,
}:
buildRedist {
  # Starting with CUDA 13.4, cuda_compat is no longer in the CUDA manifest but in the driver redist.
  # See ../_cuda/manifests/nvidia-driver/README.md
  redistName = if manifests.cuda ? cuda_compat then "cuda" else "nvidia-driver";
  pname = "cuda_compat";

  # NOTE: Using multiple outputs with symlinks causes build cycles.
  # To avoid that (and troubleshooting why), we just use a single output.
  outputs = [ "out" ];

  # libnvidia-pkcs11{-openssl3}.so is only shipped on x86_64-linux
  buildInputs = lib.optionals stdenv.hostPlatform.isx86_64 [
    openssl
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libnvdla_runtime.so"
    "libnvrm_gpu.so"
    "libnvrm_mem.so"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # Used by libnvidia-pkcs11.so but openssl_1_1 has been removed from nixpkgs (EoL)
    "libcrypto.so.1.1"
  ];

  meta = {
    description = "Provides minor version forward compatibility for the CUDA runtime";
    homepage = "https://docs.nvidia.com/deploy/cuda-compatibility";
    # Keep the license independent of where the archive is fetched from.
    license = lib.licenses.nvidiaCudaRedist;
    problems = lib.optionalAttrs (!config.enableCudaDriverCompat) {
      cuda-compat-disabled = {
        kind = "broken";
        message = "cuda_compat must be explicitly enabled using config.enableCudaDriverCompat.";
      };
    };
  };
}
