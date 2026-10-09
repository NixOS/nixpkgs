{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "spdx_licenses";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/kit-ty-kate/spdx_licenses/releases/download/v${finalAttrs.version}/spdx_licenses-${finalAttrs.version}.tar.gz";
    hash = "sha256-ciUka6XWRg2bYqzXWOGsNc62J5OshtXNSDCqbPooGVA=";
  };

  doCheck = true;

  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/kit-ty-kate/spdx_licenses";
    description = "Library providing a strict SPDX License Expression parser";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
