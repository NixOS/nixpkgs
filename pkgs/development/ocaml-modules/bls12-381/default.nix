{ lib, buildDunePackage, fetchFromGitLab, ff-sig, ff-pbt, zarith
, zarith_stubs_js, integers, integers_stubs_js, hex, alcotest }:

buildDunePackage rec {
  pname = "bls12-381";
  version = "3.0.1";

  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-bls12-381";
    rev = "22247018c0651ea62ae898c8ffcc388cc73f758f";
    sha256 = "sha256-ScKEkv+a83XJgcK9xiUqVQECoGT3PPx9stzz9QReu5I=";
  };

  strictDeps = true;

  minimalOCamlVersion = "4.08";

  buildInputs = [
    ff-sig
    hex
    integers
    integers_stubs_js
    zarith
    zarith_stubs_js
  ]
  ++ checkInputs; # dune builds tests at build-time

  checkInputs = [
    alcotest
    ff-pbt
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "OCaml binding for bls12-381 from librustzcash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
