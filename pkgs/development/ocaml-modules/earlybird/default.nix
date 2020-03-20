{ lib, fetchurl, ocaml, buildDunePackage, angstrom, angstrom-lwt-unix,
  batteries, cmdliner, lwt_ppx, ocaml_lwt, ppx_deriving_yojson,
  ppx_tools_versioned, yojson }:

if lib.versionAtLeast ocaml.version "4.08"
then throw "earlybird is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "earlybird";
  version = "0.1.5";

  minimumOCamlVersion = "4.04";

  src = fetchurl {
    url = "https://github.com/hackwaly/ocamlearlybird/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "10yflmsicw4sdmm075zjpbmxpwm9fvibnl3sl18zjpwnm6l9sv7d";
  };

  buildInputs = [ angstrom angstrom-lwt-unix batteries cmdliner lwt_ppx ocaml_lwt ppx_deriving_yojson ppx_tools_versioned yojson ];

  meta = {
    homepage = "https://github.com/hackwaly/ocamlearlybird";
    description = "OCaml debug adapter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.romildo ];
  };
}
