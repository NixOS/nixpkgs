_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    homepage = "https://docs.nvidia.com/cuda";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_documentation";
    changelog = "https://docs.nvidia.com/cuda/cuda-toolkit-release-notes";
  };
}
