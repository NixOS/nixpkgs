{ stdenv, fetchurl, libev, buildDunePackage, zed, lwt_log, lwt_react }:

buildDunePackage rec {
  pname = "lambda-term";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/ocaml-community/lambda-term/releases/download/${version}/lambda-term-${version}.tbz";
    sha256 = "1p9yczrx78pf5hvhcg1qiqb2vdlmw6bmhhjsm4wiqjq2cc6piaqw";
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
