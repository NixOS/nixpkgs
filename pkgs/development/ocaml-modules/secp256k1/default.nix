{ lib, fetchFromGitHub, buildDunePackage, base, stdio, dune-configurator, secp256k1 }:

buildDunePackage rec {
  pname = "secp256k1";
  version = "0.4.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "dakk";
    repo = "secp256k1-ml";
    rev = version;
    sha256 = "0jkd7mc5kynhg0b76dfk70pww97qsq2jbd991634i16xf8qja9fj";
  };

  buildInputs = [ base stdio dune-configurator secp256k1 ];

  meta = with lib; {
    homepage = "https://github.com/dakk/secp256k1-ml";
    description = "Elliptic curve library secp256k1 wrapper for Ocaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
