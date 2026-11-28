{
  lib,
  fetchurl,
  ppxlib,
  ppx_deriving,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "sel";
  version = "0.10.0";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/gares/sel/releases/download/v${finalAttrs.version}/sel-${finalAttrs.version}.tbz";
    hash = "sha256-kVFDGrrsMK65Ok9WGFh1FgI/mUWt6EVV1ulsxRdhbNo=";
  };

  buildInputs = [
    ppxlib
  ];

  propagatedBuildInputs = [
    ppx_deriving
  ];

  meta = {
    description = "Simple event library";
    homepage = "https://github.com/gares/sel/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
