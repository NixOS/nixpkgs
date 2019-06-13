{ callPackage, fetchurl, tcl, stdenv, ... } @ args:

callPackage ./generic.nix (args // rec {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}.1-src.tar.gz"; # TODO: remove '.1' for v8.6.10 or v8.7.x
    sha256 = "1d7bfkxpacy33w5nahf73lkwxqpff44w1jplg7i2gmwgiaawvjwg";
  };

  patches = [ ./different-prefix-with-tcl.patch ] ++ stdenv.lib.optionals stdenv.isDarwin [ ./Fix-bad-install_name-for-libtk8.6.dylib.patch ];

})
