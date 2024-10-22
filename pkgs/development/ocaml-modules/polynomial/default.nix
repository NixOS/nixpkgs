{ lib
, fetchFromGitLab
, buildDunePackage
, zarith
, ff-sig
}:

buildDunePackage rec {
  pname = "polynomial";
  version = "0.4.0";
  duneVersion = "3";
  minimalOCamlVersion = "4.08";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "cryptography/ocaml-polynomial";
    rev = version;
    hash = "sha256-is/PrYLCwStHiQsNq5OVRCwHdXjO2K2Z7FrXgytRfAU=";
  };

  propagatedBuildInputs = [ zarith ff-sig ];

  doCheck = false; # circular dependencies

  meta = {
    description = "Polynomials over finite field";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/nomadic-labs/ocaml-polynomial";
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
