{ lib, fetchurl, buildDunePackage, cppo, gettext, fileutils, ounit }:

buildDunePackage rec {
  pname = "gettext";
  version = "0.4.2";

  minimumOCamlVersion = "4.03";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-gettext/releases/download/v${version}/gettext-v${version}.tbz";
    sha256 = "19ynsldb21r539fiwz1f43apsdnx7hj2a2d9qr9wg2hva9y2qrwb";
  };

  buildInputs = [ cppo ];

  propagatedBuildInputs = [ gettext fileutils ];

  doCheck = true;

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
