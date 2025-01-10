{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "randomconv";
  version = "0.2.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/hannesm/randomconv/releases/download/v${version}/randomconv-${version}.tbz";
    hash = "sha256-sxce3wfjQaRGj5L/wh4qiGO4LtXDb3R3zJja8F1bY+o=";
  };

  meta = {
    homepage = "https://github.com/hannesm/randomconv";
    description = "Convert from random bytes to random native numbers";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
