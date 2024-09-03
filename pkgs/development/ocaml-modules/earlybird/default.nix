{ lib, fetchFromGitHub, buildDunePackage
, cmdliner, dap, fmt, iter, logs, lru, lwt_ppx, lwt_react, menhir, menhirLib, path_glob, ppx_deriving_yojson
, ppx_optcomp
, gitUpdater
}:

buildDunePackage rec {
  pname = "earlybird";
  version = "1.3.2";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "hackwaly";
    repo = "ocamlearlybird";
    rev = version;
    hash = "sha256-E6ZZRkGO6Bqr6jWlV9fL3ibFwUVChHR17TPGeP94hfk=";
  };

  nativeBuildInputs = [ menhir ];

  buildInputs = [
    cmdliner
    dap
    fmt
    iter
    logs
    lru
    lwt_ppx
    lwt_react
    menhirLib
    path_glob
    ppx_deriving_yojson
    ppx_optcomp
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/hackwaly/ocamlearlybird";
    description = "OCaml debug adapter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.romildo ];
  };
}
