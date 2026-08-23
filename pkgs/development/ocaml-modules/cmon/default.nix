{
  lib,
  fetchurl,
  buildDunePackage,
  grenier,
  pprint,
}:

buildDunePackage (finalAttrs: {
  pname = "cmon";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/let-def/cmon/releases/download/v${finalAttrs.version}/cmon-${finalAttrs.version}.tbz";
    hash = "sha256-lJi5NV27YqyDgUx1i4vBj/buzyzdWJSrSceGGs82grg=";
  };

  propagatedBuildInputs = [
    grenier
    pprint
  ];

  doCheck = true;

  meta = {
    description = "A library for printing OCaml values with sharing";
    license = lib.licenses.mit;
    homepage = "https://github.com/let-def/cmon";
  };
})
