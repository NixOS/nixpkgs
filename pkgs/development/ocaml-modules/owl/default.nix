{ stdenv
, buildDunePackage
, dune-configurator
, fetchFromGitHub
, alcotest
, ctypes
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
    ctypes
    openblasCompat
    owl-base
    npy
  ];

  doCheck = !stdenv.isDarwin; # https://github.com/owlbarn/owl/issues/462
}
