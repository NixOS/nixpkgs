_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "APIs which can be used at runtime to combine multiple CUDA objects into one CUDA fat binary (fatbin)";
    homepage = "https://docs.nvidia.com/cuda/nvfatbin";
  };
}
