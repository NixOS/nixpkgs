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
  version = "0.3";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ocaml-secp256k1-internal";
    rev = version;
    sha256 = "sha256-1wvQ4RW7avcGsIc0qgDzhGrwOBY0KHrtNVHCj2cgNzo=";
  };

  minimalOCamlVersion = "4.08";

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
