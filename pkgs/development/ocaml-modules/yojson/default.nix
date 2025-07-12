{
  lib,
  fetchurl,
  buildDunePackage,
  seq,
}:

buildDunePackage rec {
  pname = "yojson";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    hash = "sha256-mUFNp2CbkqAkdO9LSezaFe3Iy7pSKTQbEk5+RpXDlhA=";
  };

  propagatedBuildInputs = [ seq ];

  meta = {
    description = "Optimized parsing and printing library for the JSON format";
    longDescription = ''
      Yojson is an optimized parsing and printing library for the JSON format.

      ydump is a pretty-printing command-line program provided with the
      yojson package.
    '';
    changelog = "https://raw.githubusercontent.com/ocaml-community/${pname}/refs/tags/${version}/CHANGES.md";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vbgl ];
    mainProgram = "ydump";
  };
}
