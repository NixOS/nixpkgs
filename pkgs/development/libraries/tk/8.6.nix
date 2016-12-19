{ callPackage, fetchurl, tcl, stdenv, ... } @ args:

callPackage ./generic.nix (args // rec {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
    sha256 = "17diivcfcwdhp4v5zi6j9nkxncccjqkivhp363c4wx5lf4d3fb6n";
  };

  patches = [ ./different-prefix-with-tcl.patch ] ++ stdenv.lib.optionals stdenv.isDarwin [ ./Fix-bad-install_name-for-libtk8.6.dylib.patch ];

})

