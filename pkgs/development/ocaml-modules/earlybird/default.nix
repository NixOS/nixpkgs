{ lib, fetchFromGitHub, ocaml, buildDunePackage
, cmdliner, dap, fmt, iter, logs, lru, lwt_ppx, lwt_react, menhir, menhirLib, path_glob, ppx_deriving_yojson
<<<<<<< HEAD
, ppx_optcomp
, gitUpdater
}:

buildDunePackage rec {
  pname = "earlybird";
  version = "1.2.1";

  minimalOCamlVersion = "4.12";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hackwaly";
    repo = "ocamlearlybird";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-p29uTdx8+mZKXUL+ng/FzpKuhnykEe8Sy968Wa/KUn4=";
=======
    hash = "sha256-8JHZWsgpz2pzpDxST3bkMSmPHtj7MDzD5G3ujqMW+MU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ menhir ];

<<<<<<< HEAD
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
=======
  buildInputs = [ cmdliner dap fmt iter logs lru lwt_ppx lwt_react menhirLib path_glob ppx_deriving_yojson ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/hackwaly/ocamlearlybird";
    description = "OCaml debug adapter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.romildo ];
  };
}
