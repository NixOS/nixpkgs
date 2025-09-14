{
  buildDunePackage,
  fetchurl,
  lib,
  ppxlib,
}:

let
  version = "0.16.0";
in
buildDunePackage {
  pname = "reason-react-ppx";
  inherit version;
  minimalOCamlVersion = "4.14";
  src = fetchurl {
    url = "https://github.com/reasonml/reason-react/releases/download/${version}/reason-react-${version}.tbz";
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
}
