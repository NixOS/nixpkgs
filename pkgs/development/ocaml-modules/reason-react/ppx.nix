{
  buildDunePackage,
  fetchurl,
  lib,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "reason-react-ppx";
  version = "0.16.0";
  minimalOCamlVersion = "4.14";
  src = fetchurl {
    url = "https://github.com/reasonml/reason-react/releases/download/${finalAttrs.version}/reason-react-${finalAttrs.version}.tbz";
    hash = "sha256-esPB+mvHHTQ3mUYILrkOjMELJxRDIsWleFcxIwOPQ1w=";
  };
  buildInputs = [ ppxlib ];
  doCheck = false; # Needs to run in reason-react, see default.nix
  meta = {
    description = "React.js JSX PPX";
    homepage = "https://github.com/reasonml/reason-react";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
    broken = lib.versionAtLeast ppxlib.version "0.36";
  };
})
