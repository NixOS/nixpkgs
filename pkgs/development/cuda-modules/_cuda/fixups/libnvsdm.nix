_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      # TODO(@connorbaker): Not sure this is the correct set of outputs.
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "NVSwitch Device Monitoring API";
    homepage = "https://github.com/NVIDIA/nvsdm";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libnvsdm";
    changelog = "https://github.com/NVIDIA/nvsdm/releases";
  };
}
