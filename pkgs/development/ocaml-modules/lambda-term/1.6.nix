{ stdenv, fetchurl, libev, ocaml, findlib, ocamlbuild, lwt, ocaml_react, zed, camlp4 }:

stdenv.mkDerivation rec {
  version = "1.6";
  name = "lambda-term-${version}";

  src = fetchurl {
    url = https://github.com/diml/lambda-term/archive/1.6.tar.gz;
    sha256 = "1rhfixdgpylxznf6sa9wr31wb4pjzpfn5mxhxqpbchmpl2afwa09";
  };

  buildInputs = [ libev ocaml findlib ocamlbuild lwt ocaml_react ];

  propagatedBuildInputs = [ camlp4 zed ];

  createFindlibDestdir = true;

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
    platforms = ocaml.meta.platforms or [];
    branch = "1.6";
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
