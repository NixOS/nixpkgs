{
  curl,
  libibmad,
  libibumad,
  rdma-core,
  ucx,
  zlib,
}:
finalAttrs: prevAttrs: {
  postUnpack = prevAttrs.postUnpack or "" + ''
    nixLog "moving collectx_bringup to the top level of source root"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/opt/nvidia/collectx_bringup"/* \
      "$PWD/${finalAttrs.src.name}/"
    rm --dir --verbose --recursive "$PWD/${finalAttrs.src.name}/opt"
  '';

  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    curl
    libibmad
    libibumad
    rdma-core
    ucx
    zlib
  ];

  passthru = prevAttrs.passthru or { } // {
    brokenAssertions = prevAttrs.passthru.brokenAssertions or [ ] ++ [
      # NOTE: Neither of these are available in Nixpkgs, from what I can tell by way of
      # nix-community/nix-index-database.
      {
        message = "libssl.so.1.1 is available";
        assertion = false;
      }
      {
        message = "libcrypto.so.1.1 is available";
        assertion = false;
      }
    ];

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      # TODO: Has python packages, bin, etc, lib, share, and collectx directory,
      # which has its own bin and lib directories.
      outputs = [ "out" ];
    };
  };
}
