{ lib, fetchFromGitHub, buildDunePackage, base, stdio, dune-configurator, secp256k1 }:

buildDunePackage rec {
  pname = "secp256k1";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "dakk";
    repo = "secp256k1-ml";
    rev = version;
    hash = "sha256-22+dZb3MC1W5Qvsz3+IHV1/XiGCRmJHTH+6IW2QX2hU=";
  };

  buildInputs = [ base stdio dune-configurator secp256k1 ];

  meta = with lib; {
    homepage = "https://github.com/dakk/secp256k1-ml";
    description = "Elliptic curve library secp256k1 wrapper for Ocaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
