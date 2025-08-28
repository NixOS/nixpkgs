{ libxcrypt-legacy }:
finalAttrs: prevAttrs: {
  postUnpack = prevAttrs.postUnpack or "" + ''
    nixLog "moving items in usr to the top level of source root"
    mv --verbose --no-clobber \
      "$PWD/${finalAttrs.src.name}/usr"/* \
      "$PWD/${finalAttrs.src.name}/"
    rm --dir --verbose --recursive "$PWD/${finalAttrs.src.name}/usr"
  '';

  buildInputs = prevAttrs.buildInputs or [ ] ++ [ libxcrypt-legacy ];

  passthru = prevAttrs.passthru or { } // {
    brokenAssertions = prevAttrs.passthru.brokenAssertions or [ ] ++ [
      {
        # Contains problems similar to mft_autocomplete.
        message = "contains no references to FHS paths";
        assertion = false;
      }
    ];

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };
}
