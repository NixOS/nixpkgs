{
  lib,
  buildDunePackage,
  fetchurl,
  version ? "2.16.0",
}:

let
  hash =
    if version == "2.16.0" then
      "sha256-Wea0RWICQcvWkBqEKzNmg6+w6xJbOtv+4ovZTNVODe8="
    else if version == "2.15.0" then
      "sha256-ukJ5vtVNE9zz9nA6SzF0TbgV3yLAUC2ZZdbGdM4IOTM="
    else
      throw "unsupported version";
in
buildDunePackage {
  pname = "atdgen-codec-runtime";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atd-${version}.tbz";
    inherit hash;
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
