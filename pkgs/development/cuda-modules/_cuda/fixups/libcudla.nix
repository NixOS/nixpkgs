{ backendStdenv, lib }:
prevAttrs: {
  autoPatchelfIgnoreMissingDeps =
    prevAttrs.autoPatchelfIgnoreMissingDeps or [ ]
    ++ lib.optionals backendStdenv.hasJetsonCudaCapability [
      "libnvcudla.so"
    ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "stubs"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libcudla";
  };
}
