{
  _cuda,
  buildRedist,
  cuda_cudart,
  lib,
  ucc,
}:
buildRedist (finalAttrs: {
  redistName = "cublasmp";
  pname = "libcal";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  allowFHSReferences = true;

  buildInputs = [
    (lib.getOutput "stubs" cuda_cudart)
    ucc
  ];

  # TODO: UCC looks for share/ucc.conf in the same output as the shared object files, so we need to make a hook to set
  # the environment variable UCC_CONF_PATH to the correct location.
  postInstall = ''
    mkdir -p "$out/nix-support"
    cat "${./set-ucc-config-file-hook.sh}" >> "$out/nix-support/setup-hook"
    substituteInPlace "$out/nix-support/setup-hook" \
      --replace-fail "@out@" "${placeholder "out"}"
    nixLog "installed set-ucc-config-file-hook.sh"
  '';

  meta = {
    description = "Helper module for the cuBLASMp library that allows it to efficiently perform communications between different GPUs";
    longDescription = ''
      Communication Abstraction Library (CAL) is a helper module for the cuBLASMp library that allows it to
      efficiently perform communications between different GPUs.
    '';
    homepage = "https://docs.nvidia.com/cuda/cublasmp/usage/cal.html";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
    license = _cuda.lib.licenses.math_sdk_sla;
  };
})
