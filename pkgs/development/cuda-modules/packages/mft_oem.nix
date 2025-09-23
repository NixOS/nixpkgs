{ buildRedist, libxcrypt-legacy }:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "mft_oem";

  outputs = [ "out" ];

  postUnpack = ''
    nixLog "moving items in usr to the top level of source root"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/usr"/* \
      "$PWD/${finalAttrs.src.name}/"
    rm --dir --verbose --recursive "$PWD/${finalAttrs.src.name}/usr"
  '';

  buildInputs = [ libxcrypt-legacy ];

  brokenAssertions = [
    {
      # Contains problems similar to mft_autocomplete.
      message = "contains no references to FHS paths";
      assertion = false;
    }
  ];
})
