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

buildDunePackage (finalAttrs: {
  pname = "secp256k1";
  version = "0.5.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "dakk";
    repo = "secp256k1-ml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PD+4+OE0ttQsyG+i5Ez9kdo1A2DPNxvUjRQHXXSxaKo=";
  };

  buildInputs = [
    base
    stdio
    dune-configurator
    secp256k1
  ];

  meta = {
    homepage = "https://github.com/dakk/secp256k1-ml";
    description = "Elliptic curve library secp256k1 wrapper for Ocaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vyorkin ];
  };
})
