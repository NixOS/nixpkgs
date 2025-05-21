{ lib
, stdenv
, callPackage
, fetchurl
, fetchpatch
, tcl
, ...
} @ args:

callPackage ./generic.nix (args // {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
    sha256 = "1yhgcalldrjlc5q614rlzg1crgd3b52dhrk1pncdaxvl2vgg2yj0";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Define MODULE_SCOPE before including tkPort.h
    # https://core.tcl-lang.org/tk/info/dba9f5ce3b
    (fetchpatch {
      name = "module_scope.patch";
      url = "https://core.tcl-lang.org/tk/vpatch?from=ef6c6960c53ea30c&to=9b8aa74eebed509a";
      extraPrefix = "";
      sha256 = "0crhf4zrzdpc1jdgyv6l6mxqgmny12r3i39y1i0j8q3pbqkd04bv";
    })
  ];

})
