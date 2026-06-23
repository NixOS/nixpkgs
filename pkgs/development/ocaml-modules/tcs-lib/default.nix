{
  lib,
  fetchurl,
  buildDunePackage,
  num,
}:

buildDunePackage (finalAttrs: {
  pname = "tcs-lib";
  version = "0.6";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/tcsprojects/tcslib/releases/download/v${finalAttrs.version}/tcs-lib-${finalAttrs.version}.tbz";
    hash = "sha256-DBjdIOUrYbfN3VlTaQMIGezPpOpzv9vtmDmBVYZigSI=";
  };

  propagatedBuildInputs = [
    num
  ];

  meta = {
    homepage = "https://github.com/tcsprojects/tcslib";
    description = "Multi-purpose library for OCaml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
})
