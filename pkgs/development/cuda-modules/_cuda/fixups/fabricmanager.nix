{ zlib }:
prevAttrs: {
  allowFHSReferences = true;

  buildInputs = prevAttrs.buildInputs or [ ] ++ [ zlib ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "bin"
        "dev"
        "include"
        "lib"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    homepage = "https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/fabricmanager";
  };
}
