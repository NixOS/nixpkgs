{ lib, buildDunePackage, fetchFromGitLab, ff-sig, zarith }:

buildDunePackage rec {
  pname = "bls12-381";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-bls12-381";
    rev = "22247018c0651ea62ae898c8ffcc388cc73f758f";
    sha256 = "ku6Rc+/lwFDoHTZTxgkhiF+kLkagi7944ntcu9vXWgI=";
  };

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    ff-sig
    zarith
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "OCaml binding for bls12-381 from librustzcash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
