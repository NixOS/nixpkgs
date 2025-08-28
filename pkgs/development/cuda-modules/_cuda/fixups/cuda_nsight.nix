_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Nsight Eclipse Plugins Edition";
    longDescription = ''
      NVIDIA Nsight Eclipse Edition is a unified CPU plus GPU integrated development environment (IDE) for developing
      CUDA applications on Linux and Mac OS X for the x86, POWER and ARM platforms. It is designed to help developers
      on all stages of the software development process.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/nsight-eclipse-plugins-guide";
  };
}
