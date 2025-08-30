_: finalAttrs: prevAttrs: {
  postUnpack = prevAttrs.postUnpack or "" + ''
    nixLog "moving sbin to bin"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/sbin" \
      "$PWD/${finalAttrs.src.name}/bin"
  '';

  passthru = prevAttrs.passthru or { } // {
    brokenAssertions = prevAttrs.passthru.brokenAssertions or [ ] ++ [
      {
        # The binary files match FHS paths and the configuration files need to be patched.
        message = "contains no references to FHS paths";
        assertion = false;
      }
    ];

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      # TODO: includes bin, lib, and share directories.
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "NVLink Subnet Manager";
    longDescription = ''
      A service that originates from NVIDIA InfiniBand switches and has the necessary modifications to effectively manage NVSwitches.
    ''
    + prevAttrs.meta.longDescription;
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/nvlsm";
  };
}
