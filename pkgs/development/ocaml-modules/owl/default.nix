{ stdenv
, buildDunePackage
, dune-configurator
, fetchFromGitHub
, alcotest
, eigen
, stdio
, stdlib-shims
, openblas, blas, lapack
, owl-base
, npy
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert blas.implementation == "openblas" && lapack.implementation == "openblas";

buildDunePackage rec {
  pname = "owl";

  inherit (owl-base) version src meta useDune2;

  checkInputs = [ alcotest ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    eigen stdio stdlib-shims openblas owl-base npy
  ];

  doCheck = !stdenv.isDarwin;  # https://github.com/owlbarn/owl/issues/462
}
