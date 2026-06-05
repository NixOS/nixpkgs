{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  menhir,
}:

buildDunePackage (finalAttrs: {
  version = "0.4.0";
  pname = "psmt2-frontend";

  src = fetchFromGitHub {
    owner = "ACoquereau";
    repo = "psmt2-frontend";
    rev = finalAttrs.version;
    hash = "sha256-cYY9x7QZjH7pdJyHMqfMXgHZ3/zJLp/6ntY6OSIo6Vs=";
  };

  minimalOCamlVersion = "4.03";

  nativeBuildInputs = [ menhir ];

  meta = {
    description = "Simple parser and type-checker for polomorphic extension of the SMT-LIB 2 language";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (finalAttrs.src.meta) homepage;
  };

})
