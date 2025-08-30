{
  cuda_cudart,
  lib,
  ucc,
}:
finalAttrs: prevAttrs: {
  allowFHSReferences = true;

  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    (lib.getOutput "stubs" cuda_cudart)
    ucc
  ];

  # TODO: UCC looks for share/ucc.conf in the same output as the shared object files, so we need to make a hook to set
  # the environment variable UCC_CONF_PATH to the correct location.
  postInstall = lib.optionalString (lib.elem "out" finalAttrs.outputs) ''
    mkdir -p "$out/nix-support"
    cat "${./set-ucc-config-file-hook.sh}" >> "$out/nix-support/setup-hook"
    substituteInPlace "$out/nix-support/setup-hook" \
      --replace-fail "@out@" "${placeholder "out"}"
    nixLog "installed set-ucc-config-file-hook.sh"
  '';

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Helper module for the cuBLASMp library that allows it to efficiently perform communications between different GPUs";
    longDescription = ''
      Communication Abstraction Library (CAL) is a helper module for the cuBLASMp library that allows it to
      efficiently perform communications between different GPUs.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/cublasmp/usage/cal.html";
    downloadPage = "https://developer.download.nvidia.com/compute/cublasmp/redist/libcal";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
  };
}
