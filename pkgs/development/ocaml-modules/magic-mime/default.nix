{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "magic-mime";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-magic-mime/releases/download/v${version}/magic-mime-${version}.tbz";
    hash = "sha256-4CNNA2Jduh76xY5X44dnLXWl6aYh/0ms/g9gnADxOwg=";
  };

  minimalOCamlVersion = "4.03";

  meta = with lib; {
    description = "Convert file extensions to MIME types";
    homepage = "https://github.com/mirage/ocaml-magic-mime";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
