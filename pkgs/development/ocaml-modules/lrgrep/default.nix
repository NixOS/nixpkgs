{
  lib,
  fetchurl,
  buildDunePackage,
  menhir,
  cmon,
  menhirLib,
  menhirSdk,
}:

buildDunePackage (finalAttrs: {
  pname = "lrgrep";
  version = "0.9";

  minimalOCamlVersion = "4.14";

  src = fetchurl {
    url = "https://github.com/let-def/lrgrep/releases/download/v${finalAttrs.version}/lrgrep-${finalAttrs.version}.tbz";
    hash = "sha256-5T3hLkxcvmvKAGQ1kyZrT5+i4/ahOBle7/ekMp9cHHU=";
  };

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [
    cmon
    menhirLib
    menhirSdk
  ];

  doCheck = true;

  meta = {
    license = lib.licenses.isc;
    description = "Detailed error messages for Menhir-generated parsers";
    homepage = "https://github.com/let-def/lrgrep";
  };
})
