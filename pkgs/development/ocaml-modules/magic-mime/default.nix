{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "magic-mime";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-magic-mime/releases/download/v${version}/magic-mime-v${version}.tbz";
    sha256 = "sha256-8SG2dQD43Zfi/J/V0BxzJeTIS8XAI3RCd5+9b6IGlPU=";
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
