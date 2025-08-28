{ rdma-core, zlib }:
finalAttrs: prevAttrs: {
  postUnpack = prevAttrs.postUnpack or "" + ''
    nixLog "moving items in usr to the top level of source root"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/usr"/* \
      "$PWD/${finalAttrs.src.name}/"
    rm --dir --verbose --recursive "$PWD/${finalAttrs.src.name}/usr"
  '';

  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    rdma-core
    zlib
  ];

  passthru = prevAttrs.passthru or { } // {
    brokenAssertions = prevAttrs.passthru.brokenAssertions or [ ] ++ [
      {
        # There are a *bunch* of these references and I don't know how to patch them all.
        message = "contains no references to FHS paths";
        assertion = false;
      }
    ];

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      # TODO: includes bin, etc, include, lib, and share directories.
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "NVIDIA firmware management tools";
    homepage = "https://network.nvidia.com/products/adapter-software/firmware-tools/";
  };
}
