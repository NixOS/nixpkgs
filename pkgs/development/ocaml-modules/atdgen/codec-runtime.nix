{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "atdgen-codec-runtime";
  version = "2.9.1";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atdts-${version}.tbz";
    sha256 = "sha256-OdwaUR0Ix0Oz8NDm36nIyvIRzF+r/pKgiej1fhcOmuQ=";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
