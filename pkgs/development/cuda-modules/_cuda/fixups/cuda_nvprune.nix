_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Prune host object files and libraries to only contain device code for the specified targets";
    longDescription = ''
      `nvprune` prunes host object files and libraries to only contain device code for the specified targets.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/cuda-binary-utilities#nvprune";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvprune";
  };
}
