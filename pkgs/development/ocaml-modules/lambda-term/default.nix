{ lib, fetchFromGitHub, buildDunePackage, ocaml, zed, lwt_log, lwt_react, mew_vi, uucp, logs }:

let params =
  if lib.versionAtLeast ocaml.version "4.08" then {
    version = "3.3.2";
    sha256 = "sha256-T2DDpHqLar1sgmju0PLvhAZef5VzOpPWcFVhuZlPQmM=";
  } else {
    version = "3.1.0";
    sha256 = "1k0ykiz0vhpyyj9fkss29ajas4fh1xh449j702xkvayqipzj1mkg";
  }
; in

buildDunePackage rec {
  pname = "lambda-term";
  inherit (params) version;

  duneVersion = if lib.versionAtLeast ocaml.version "4.08" then "3" else "2";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = version;
    inherit (params) sha256;
  };

  propagatedBuildInputs = [ zed lwt_log lwt_react mew_vi ]
    ++ lib.optionals (lib.versionAtLeast version "3.3.1") [ uucp logs ] ;

  meta = {
    description = "Terminal manipulation library for OCaml";
    longDescription = ''
    Lambda-term is a cross-platform library for
    manipulating the terminal. It provides an abstraction for keys,
    mouse events, colors, as well as a set of widgets to write
    curses-like applications.

    The main objective of lambda-term is to provide a higher level
    functional interface to terminal manipulation than, for example,
    ncurses, by providing a native OCaml interface instead of bindings to
    a C library.

    Lambda-term integrates with zed to provide text edition facilities in
    console applications.
    '';

    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.gal_bolle ];
    mainProgram = "lambda-term-actions";
  };
}
