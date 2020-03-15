{ stdenv, fetchurl, libev, buildDunePackage, zed, lwt_log, lwt_react }:

buildDunePackage rec {
  pname = "lambda-term";
  version = "2.0.3";

  src = fetchurl {
    url = "https://github.com/ocaml-community/lambda-term/releases/download/${version}/lambda-term-${version}.tbz";
    sha256 = "1n1b3ffj41a1lm2315hh870yj9h8gg8g9jcxha6dr3xx8r84np3v";
  };

  buildInputs = [ libev ];
  propagatedBuildInputs = [ zed lwt_log lwt_react ];

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

    homepage = https://github.com/diml/lambda-term;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
