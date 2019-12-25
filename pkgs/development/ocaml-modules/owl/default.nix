{ stdenv, buildDunePackage, fetchFromGitHub, alcotest
, eigen, stdio, stdlib-shims, openblasCompat, owl-base
}:

buildDunePackage rec {
  pname = "owl";

  inherit (owl-base) version src meta;

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ eigen stdio stdlib-shims openblasCompat owl-base ];

  doCheck = !stdenv.isDarwin;  # https://github.com/owlbarn/owl/issues/462
}
