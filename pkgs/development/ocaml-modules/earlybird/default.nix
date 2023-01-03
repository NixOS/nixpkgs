{ lib, fetchFromGitHub, ocaml, buildDunePackage
, cmdliner, dap, fmt, iter, logs, lru, lwt_ppx, lwt_react, menhir, menhirLib, path_glob, ppx_deriving_yojson
, gitUpdater
}:

if lib.versionAtLeast ocaml.version "4.13"
then throw "earlybird is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "earlybird";
  version = "1.1.0";

  duneVersion = "3";

  minimalOCamlVersion = "4.11";

  src = fetchFromGitHub {
    owner = "hackwaly";
    repo = "ocamlearlybird";
    rev = version;
    hash = "sha256-8JHZWsgpz2pzpDxST3bkMSmPHtj7MDzD5G3ujqMW+MU=";
  };

  buildInputs = [ cmdliner dap fmt iter logs lru lwt_ppx lwt_react menhir menhirLib path_glob ppx_deriving_yojson ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/hackwaly/ocamlearlybird";
    description = "OCaml debug adapter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.romildo ];
  };
}
