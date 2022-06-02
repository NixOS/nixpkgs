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
  version = "0.2";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ocaml-secp256k1-internal";
    rev = "v${version}";
    sha256 = "1g9fyi78nmmm19l2cggwj14m4n80rz7gmnh1gq376zids71s6qxv";
  };

  useDune2 = true;

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
