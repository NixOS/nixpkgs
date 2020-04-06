{ stdenv
, buildDunePackage
, dune-configurator
, fetchFromGitHub
, alcotest
, eigen
, stdio
, stdlib-shims
, openblasCompat
, owl-base
, npy
}:

buildDunePackage rec {
  pname = "owl";

  inherit (owl-base) version src meta useDune2;

  checkInputs = [ alcotest ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    eigen stdio stdlib-shims openblasCompat owl-base npy
  ];

  doCheck = !stdenv.isDarwin;  # https://github.com/owlbarn/owl/issues/462
}
