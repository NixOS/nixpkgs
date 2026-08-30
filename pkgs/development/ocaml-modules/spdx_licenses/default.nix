{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "spdx_licenses";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/kit-ty-kate/spdx_licenses/releases/download/v${finalAttrs.version}/spdx_licenses-${finalAttrs.version}.tar.gz";
    hash = "sha256-Q+z+B/2yHiiulK/FY75fd4+Lyt5fTcJgZwBWdzgy4EQ=";
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
