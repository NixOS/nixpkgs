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
    url = "mirror://sourceforge/tcl/tk${tcl.version}.1-src.tar.gz"; # TODO: remove '.1' for v8.6.10 or v8.7.x
    sha256 = "1gh9k7l76qg9l0sb78ijw9xz4xl1af47aqbdifb6mjpf3cbsnv00";
  };

  patches = [ ./different-prefix-with-tcl.patch ] ++ lib.optionals stdenv.isDarwin [
    ./Fix-bad-install_name-for-libtk8.6.dylib.patch
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
