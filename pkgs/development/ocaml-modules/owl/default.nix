{ stdenv
, buildDune2Package
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

buildDune2Package rec {
  pname = "owl";

  inherit (owl-base) version src meta;

  checkInputs = [ alcotest ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    eigen stdio stdlib-shims openblasCompat owl-base npy
  ];

  doCheck = !stdenv.isDarwin;  # https://github.com/owlbarn/owl/issues/462
}
