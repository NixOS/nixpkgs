{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "atdgen-codec-runtime";
  version = "2.15.0";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atd-${version}.tbz";
    hash = "sha256-ukJ5vtVNE9zz9nA6SzF0TbgV3yLAUC2ZZdbGdM4IOTM=";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
