{ callPackage, fetchurl, tcl, ... } @ args:

callPackage ./generic.nix (args // rec {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
    sha256 = "1h96vp15zl5xz0d4qp6wjyrchqmrmdm3q5k22wkw9jaxbvw9vy88";
  };

  patches = [ ./different-prefix-with-tcl.patch ];

})

