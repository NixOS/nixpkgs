{
  lib,
  fetchurl,
  buildDunePackage,
  seq,
}:

<<<<<<< HEAD
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
=======
buildDunePackage rec {
  pname = "yojson";
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    hash = "sha256-mr+tjJp51HI60vZEjmacHmjb/IfMVKG3wGSwyQkSxZU=";
  };

  propagatedBuildInputs = [ seq ];

  meta = with lib; {
    description = "Optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ydump";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
