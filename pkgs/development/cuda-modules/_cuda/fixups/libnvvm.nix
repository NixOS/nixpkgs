_: prevAttrs: {
  # Everything is nested under the nvvm directory.
  prePatch = prevAttrs.prePatch or "" + ''
    nixLog "un-nesting top-level $PWD/nvvm directory"
    mv -v "$PWD/nvvm"/* "$PWD/"
    nixLog "removing empty $PWD/nvvm directory"
    rmdir -v "$PWD/nvvm"
  '';

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      # NOTE(@connorbaker): CMake and other build systems may not react well to this library being split into multiple
      # outputs; they may use relative path accesses.
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Interface for generating PTX code from both binary and text NVVM IR inputs";
    longDescription = ''
      libNVVM API provides an interface for generating PTX code from both binary and text NVVM IR inputs.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/libnvvm-api";
  };
}
