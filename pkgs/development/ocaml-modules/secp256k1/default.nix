{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildDunePackage,
  base,
  stdio,
  dune-configurator,
  secp256k1,
}:

buildDunePackage rec {
  pname = "secp256k1";
  version = "0.4.4";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "dakk";
    repo = "secp256k1-ml";
    rev = version;
    hash = "sha256-22+dZb3MC1W5Qvsz3+IHV1/XiGCRmJHTH+6IW2QX2hU=";
  };

  patches = fetchpatch {
    url = "https://github.com/dakk/secp256k1-ml/commit/9bde90a401746dcecdab68a2fdb95659d16a3022.patch";
    hash = "sha256-QndtZJtPKPjuv84jDmXc9Q/xGLb/mNUGL4AvRecSFlQ=";
  };

  buildInputs = [
    base
    stdio
    dune-configurator
    secp256k1
  ];

  meta = with lib; {
    homepage = "https://github.com/dakk/secp256k1-ml";
    description = "Elliptic curve library secp256k1 wrapper for Ocaml";
    license = licenses.mit;
    maintainers = [ maintainers.vyorkin ];
  };
}
