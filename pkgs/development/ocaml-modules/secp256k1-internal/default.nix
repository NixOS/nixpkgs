{ lib
, fetchFromGitLab
, buildDunePackage
, gmp
, dune-configurator
, cstruct
, bigstring
, alcotest
, hex
}:

buildDunePackage rec {
  pname = "secp256k1-internal";
  version = "0.4";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ocaml-secp256k1-internal";
    rev = "v${version}";
    hash = "sha256-amVtp94cE1NxClWJgcJvRmilnQlC7z44mORUaxvPn00=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    gmp
    cstruct
    bigstring
  ];

  buildInputs = [
    dune-configurator
  ];

  checkInputs = [
    alcotest
    hex
  ];

  doCheck = true;

  meta = {
    description = "Bindings to secp256k1 internal functions (generic operations on the curve)";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
