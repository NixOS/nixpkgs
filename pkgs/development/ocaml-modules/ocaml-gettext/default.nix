{ lib, fetchurl, buildDunePackage, gettext, fileutils, ounit }:

buildDunePackage rec {
  pname = "gettext";
  version = "0.4.1";

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-gettext/releases/download/v${version}/gettext-v${version}.tbz";
    sha256 = "0pwy6ym5fd77mdbgyas8x86vbrri9cgk79g8wxdjplhyi7zhh158";
  };

  propagatedBuildInputs = [ gettext fileutils ];

  doCheck = true;

  checkInputs = lib.optional doCheck ounit;

  dontStrip = true;

  meta = with lib; {
    description = "OCaml Bindings to gettext";
    homepage = "https://github.com/gildor478/ocaml-gettext";
    license = licenses.lgpl21;
    maintainers = [ maintainers.volth ];
  };
}
