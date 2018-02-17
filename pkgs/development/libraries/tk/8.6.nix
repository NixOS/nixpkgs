{ callPackage, fetchurl, tcl, stdenv, ... } @ args:

callPackage ./generic.nix (args // rec {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
    sha256 = "0cvvznjwfn0i9vj9cw3wg8svx25ha34gg57m4xd1k5fyinhbrrs9";
  };

  patches = [ ./different-prefix-with-tcl.patch ] ++ stdenv.lib.optionals stdenv.isDarwin [ ./Fix-bad-install_name-for-libtk8.6.dylib.patch ];

})

