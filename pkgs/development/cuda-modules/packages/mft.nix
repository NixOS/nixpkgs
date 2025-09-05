{
  buildRedist,
  lib,
  rdma-core,
  zlib,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "mft";

  # TODO: includes bin, etc, include, lib, and share directories.
  outputs = [ "out" ];

  postUnpack = lib.optionalString (finalAttrs.src != null) ''
    nixLog "moving items in usr to the top level of source root"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/usr"/* \
      "$PWD/${finalAttrs.src.name}/"
    rm --dir --verbose --recursive "$PWD/${finalAttrs.src.name}/usr"
  '';

  buildInputs = [
    rdma-core
    zlib
  ];

  brokenAssertions = [
    {
      # There are a *bunch* of these references and I don't know how to patch them all.
      message = "contains no references to FHS paths";
      assertion = false;
    }
  ];

  meta = {
    description = "NVIDIA firmware management tools";
    homepage = "https://network.nvidia.com/products/adapter-software/firmware-tools/";
  };
})
