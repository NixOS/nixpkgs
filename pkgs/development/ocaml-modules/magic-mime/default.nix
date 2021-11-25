{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "magic-mime";
  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-magic-mime/releases/download/v${version}/magic-mime-v${version}.tbz";
    sha256 = "1xqjs8bba567yzrzgnr88j5ck97d36zw68zr9v29liya37k6rcvz";
  };

  minimalOCamlVersion = "4.03";
  useDune2 = true;

  meta = with lib; {
    description = "Convert file extensions to MIME types";
    homepage = "https://github.com/mirage/ocaml-magic-mime";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
