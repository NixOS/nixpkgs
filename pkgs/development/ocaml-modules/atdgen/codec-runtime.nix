{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "atdgen-codec-runtime";
  version = "2.16.0";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${version}/atd-${version}.tbz";
    hash = "sha256-Wea0RWICQcvWkBqEKzNmg6+w6xJbOtv+4ovZTNVODe8=";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
