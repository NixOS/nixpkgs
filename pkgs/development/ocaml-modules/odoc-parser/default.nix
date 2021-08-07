{ lib, fetchurl, buildDunePackage, astring, result }:

buildDunePackage rec {
  pname = "odoc-parser";
  version = "0.9.0";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocaml-doc/odoc-parser/releases/download/0.9.0/odoc-parser-0.9.0.tbz";
    sha256 = "0ydxy2sj2w9i4vvyjnxplgmp5gbkp5ilnv36pvk4vgrrmldss3fz";
  };

  useDune2 = true;

  buildInputs = [ astring result ];

  meta = {
    description = "Parser for Ocaml documentation comments";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.marsam ];
    homepage = "https://github.com/ocaml-doc/odoc-parser";
    changelog = "https://github.com/ocaml-doc/odoc-parser/raw/${version}/CHANGES.md";
  };
}
