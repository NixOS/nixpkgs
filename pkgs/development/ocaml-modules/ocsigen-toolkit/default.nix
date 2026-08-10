{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  calendar,
  cmdliner,
  eliom,
  js_of_ocaml-ppx_deriving_json,
  ocsigen-ppx-rpc,
}:

buildDunePackage (finalAttrs: {
  pname = "ocsigen-toolkit";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-toolkit";
    tag = finalAttrs.version;
    hash = "sha256-q6e8pacQ/F2vJeI4IqgyWI68J8qKq1vk3yRpI09BjLU=";
  };

  buildInputs = [
    cmdliner
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
