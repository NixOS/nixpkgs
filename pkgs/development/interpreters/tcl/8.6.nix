{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  release = "8.6";
  version = "${release}.11";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "0n4211j80mxr6ql0xx52rig8r885rcbminfpjdb2qrw6hmk8c14c";
  };
})
