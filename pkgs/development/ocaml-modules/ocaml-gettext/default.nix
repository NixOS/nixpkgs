{ lib, fetchurl, buildDunePackage, cppo, gettext, fileutils, ounit }:

buildDunePackage rec {
  pname = "gettext";
  version = "0.4.2";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-gettext/releases/download/v${version}/gettext-v${version}.tbz";
    sha256 = "19ynsldb21r539fiwz1f43apsdnx7hj2a2d9qr9wg2hva9y2qrwb";
  };

  nativeBuildInputs = [ cppo ];

  propagatedBuildInputs = [ gettext fileutils ];

  # Tests for version 0.4.2 are not compatible with OUnit 2.2.6
  doCheck = false;

  checkInputs = [ ounit ];

  dontStrip = true;

  meta = with lib; {
    description = "OCaml Bindings to gettext";
    homepage = "https://github.com/gildor478/ocaml-gettext";
    license = licenses.lgpl21;
    maintainers = [ ];
    mainProgram = "ocaml-gettext";
  };
}
