_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "APIs which can be used to compile a PTX program into GPU assembly code";
    homepage = "https://docs.nvidia.com/cuda/ptx-compiler-api";
  };
}
