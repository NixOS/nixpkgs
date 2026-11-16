{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_derivers";
  version = "1.2.1";

  minimalOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "diml";
    repo = "ppx_derivers";
    rev = finalAttrs.version;
    hash = "sha256-9k4rbB1G4894F95XPMQsiVgwZKJ2XcaDUaEviArHG3s=";
  };

  meta = {
    description = "Shared [@@deriving] plugin registry";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (finalAttrs.src.meta) homepage;
  };
})
