{ lib
, buildDunePackage
, fetchurl
}:

buildDunePackage rec {
  pname = "xml-light";
  version = "2.5";

  duneVersion = "3";
  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/ncannasse/xml-light/releases/download/${version}/xml-light-${version}.tbz";
    hash = "sha256-9YwrPbcK0boICw0wauMvgsy7ldq7ksWZzcRn0eROAD0=";
  };

  meta = {
    description = "Minimal Xml parser and printer for OCaml";
    longDescription = ''
      Xml-Light provides functions to parse an XML document into an OCaml
      data structure, work with it, and print it back to an XML
      document. It support also DTD parsing and checking, and is
      entirely written in OCaml, hence it does not require additional C
      library.
    '';
    homepage = "http://tech.motion-twin.com/xmllight.html";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.romildo ];
  };
}
