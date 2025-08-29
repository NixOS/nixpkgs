{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "spdx_licenses";
  version = "1.4.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/kit-ty-kate/spdx_licenses/releases/download/v${version}/spdx_licenses-${version}.tar.gz";
    hash = "sha256-slXewgDbf1US8kk/NaxOoicnkwdliUOq+SemkjvyUis=";
  };

  meta = {
    homepage = "https://github.com/kit-ty-kate/spdx_licenses";
    description = "Library providing a strict SPDX License Expression parser";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
