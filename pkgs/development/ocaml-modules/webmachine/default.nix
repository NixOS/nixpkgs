{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cohttp,
  dispatch,
  ptime,
  ounit,
}:

buildDunePackage rec {
  pname = "webmachine";
  version = "0.7.0";
  duneVersion = "3";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "ocaml-webmachine";
    rev = version;
    hash = "sha256-3TlBQ42tzrIU2ySfYK67P6JKOSwV5VQRUgtLKWhY1g8=";
  };

  propagatedBuildInputs = [
    cohttp
    dispatch
    ptime
  ];

  checkInputs = [ ounit ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/inhabitedtype/ocaml-webmachine";
    license = lib.licenses.bsd3;
    description = "REST toolkit for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
