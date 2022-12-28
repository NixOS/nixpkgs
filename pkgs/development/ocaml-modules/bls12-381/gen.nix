{ lib, fetchFromGitLab, buildDunePackage, ff-sig, zarith }:

buildDunePackage rec {
  pname = "bls12-381-gen";
  version = "0.4.4";

  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-bls12-381";
    rev = "${version}-legacy";
    sha256 = "qocIfQdv9rniOUykRulu2zWsqkzT0OrsGczgVKALRuk=";
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
    description = "Functors to generate BLS12-381 primitives based on stubs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
