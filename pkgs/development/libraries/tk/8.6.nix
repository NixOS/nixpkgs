{ lib
, stdenv
, callPackage
, fetchurl
, tcl
, ...
} @ args:

callPackage ./generic.nix (args // {

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tk${tcl.version}-src.tar.gz";
    sha256 = "sha256-LmX6BpojNlRAo8VsVWuGc7XjKig4ANjZslfj9YTOBnU=";
  };

  patches = [
    ./tk-8_6_13-find-library.patch
  ];

})
