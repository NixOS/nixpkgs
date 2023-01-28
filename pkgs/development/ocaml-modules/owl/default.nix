{ stdenv
, buildDunePackage
, dune-configurator
, fetchFromGitHub
, alcotest
, eigen
, stdio
, openblasCompat
, owl-base
, npy
}:


buildDunePackage rec {
  pname = "owl";

  inherit (owl-base) version src meta useDune2;

  nativeCheckInputs = [ alcotest ];
  buildInputs = [ dune-configurator stdio ];
  propagatedBuildInputs = [
    eigen openblasCompat owl-base npy
  ];

  doCheck = !stdenv.isDarwin;  # https://github.com/owlbarn/owl/issues/462
}
