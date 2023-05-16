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
    sha256 = "sha256-LmX6BpojNlRAo8VsVWuGc7XjKig4ANjZslfj9YTOBnU=";
  };

<<<<<<< HEAD
  patches = [
    ./tk-8_6_13-find-library.patch
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
