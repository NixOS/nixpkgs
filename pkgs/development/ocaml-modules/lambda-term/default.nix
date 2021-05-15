{ lib, fetchFromGitHub, buildDunePackage, zed, lwt_log, lwt_react, mew_vi }:

buildDunePackage rec {
  pname = "lambda-term";
  version = "3.1.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = version;
    sha256 = "1k0ykiz0vhpyyj9fkss29ajas4fh1xh449j702xkvayqipzj1mkg";
  };

  propagatedBuildInputs = [ zed lwt_log lwt_react mew_vi ];

  meta = { description = "Terminal manipulation library for OCaml";
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
    maintainers = [
      lib.maintainers.gal_bolle
    ];
  };
}
