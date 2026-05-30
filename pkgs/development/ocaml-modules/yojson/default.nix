{
  lib,
  fetchurl,
  buildDunePackage,
  seq,
}:

buildDunePackage (finalAttrs: {
  pname = "yojson";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${finalAttrs.version}/yojson-${finalAttrs.version}.tbz";
    hash =
      {
        "3.0.0" = "sha256-mUFNp2CbkqAkdO9LSezaFe3Iy7pSKTQbEk5+RpXDlhA=";
        "2.2.2" = "sha256-mr+tjJp51HI60vZEjmacHmjb/IfMVKG3wGSwyQkSxZU=";
      }
      ."${finalAttrs.version}";
  };

  propagatedBuildInputs = lib.optional (!lib.versionAtLeast finalAttrs.version "3.0.0") seq;

  meta = {
    description = "Optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/yojson";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "ydump";
  };
})
