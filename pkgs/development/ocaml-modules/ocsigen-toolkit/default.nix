{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  calendar,
  eliom,
  js_of_ocaml-ppx_deriving_json,
  ocsigen-ppx-rpc,
  ocsigen-dune-rules,
}:

buildDunePackage (finalAttrs: {
  pname = "ocsigen-toolkit";
  version = "4.3.0+git-2026-11-01";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-toolkit";
    rev = "3866538e5b23e40cb4bcfb4ca180bc27e4194ce1";
    hash = "sha256-+wSpkNputuWwOS/RKvzqNRNlByxqqWZ+2G4o+CpSvtk=";
  };

  nativeBuildInputs = [
    ocsigen-dune-rules
  ];

  buildInputs = [
    js_of_ocaml-ppx_deriving_json
    ocsigen-ppx-rpc
  ];

  propagatedBuildInputs = [
    calendar
    eliom
  ];

  meta = {
    homepage = "http://ocsigen.org/ocsigen-toolkit/";
    description = "User interface widgets for Ocsigen applications";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.gal_bolle ];
  };

})
