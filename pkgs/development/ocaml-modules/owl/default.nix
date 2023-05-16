{ stdenv
, buildDunePackage
, dune-configurator
, fetchFromGitHub
, alcotest
<<<<<<< HEAD
, ctypes
=======
, eigen
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, stdio
, openblasCompat
, owl-base
, npy
}:


buildDunePackage rec {
  pname = "owl";

  inherit (owl-base) version src meta;

  duneVersion = "3";

  checkInputs = [ alcotest ];
  buildInputs = [ dune-configurator stdio ];
  propagatedBuildInputs = [
<<<<<<< HEAD
    ctypes
=======
    eigen
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    openblasCompat
    owl-base
    npy
  ];

  doCheck = !stdenv.isDarwin; # https://github.com/owlbarn/owl/issues/462
}
