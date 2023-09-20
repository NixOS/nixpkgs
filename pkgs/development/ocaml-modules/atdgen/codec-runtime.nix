{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "atdgen-codec-runtime";
  version = "2.11.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atdts-${version}.tbz";
    hash = "sha256-TTTuSxNKydPmTmztUapLoxntBIrAo8aWYIJ/G5cok1Y=";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
