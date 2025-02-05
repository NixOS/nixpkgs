{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "spdx_licenses";
  version = "1.2.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/kit-ty-kate/spdx_licenses/releases/download/v${version}/spdx_licenses-${version}.tar.gz";
    hash = "sha256-9ViB7PRDz70w3RJczapgn2tJx9wTWgAbdzos6r3J2r4=";
  };

  meta = {
    homepage = "https://github.com/kit-ty-kate/spdx_licenses";
    description = "A library providing a strict SPDX License Expression parser";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
