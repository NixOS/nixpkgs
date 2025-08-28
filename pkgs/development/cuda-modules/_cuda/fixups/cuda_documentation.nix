_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    homepage = "https://docs.nvidia.com/cuda";
    changelog = "https://docs.nvidia.com/cuda/cuda-toolkit-release-notes";
  };
}
