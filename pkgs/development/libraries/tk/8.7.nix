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
    sha256 = "sha256-UiioGHp/cPoHke8Pl1Jw8Gi6lVf1dFb1HrAtnU6jEoI=";
  };

})
