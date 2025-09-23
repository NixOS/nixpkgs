{
  buildRedist,
  curl,
  lib,
  libibmad,
  libibumad,
  rdma-core,
  ucx,
  zlib,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "collectx_bringup";

  # TODO: Has python packages, bin, etc, lib, share, and collectx directory,
  # which has its own bin and lib directories.
  outputs = [ "out" ];

  postUnpack = lib.optionalString (finalAttrs.src ? name) ''
    nixLog "moving collectx_bringup to the top level of source root"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/opt/nvidia/collectx_bringup"/* \
      "$PWD/${finalAttrs.src.name}/"
    rm --dir --verbose --recursive "$PWD/${finalAttrs.src.name}/opt"
  '';

  buildInputs = [
    curl
    libibmad
    libibumad
    rdma-core
    ucx
    zlib
  ];

  brokenAssertions = [
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
})
