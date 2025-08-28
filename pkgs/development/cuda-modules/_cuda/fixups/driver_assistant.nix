_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    platformAssertions = prevAttrs.passthru.platformAssertions or [ ] ++ [
      {
        message = "Package is not supported; use drivers from linuxPackages";
        assertion = false;
      }
    ];

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };
}
