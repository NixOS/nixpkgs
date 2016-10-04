{ stdenv, fetchurl, libev, ocaml, findlib, ocaml_lwt, ocaml_react, zed }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation rec {
  version = "1.10";
  name = "lambda-term-${version}";

  src = fetchurl {
    url = "https://github.com/diml/lambda-term/archive/${version}.tar.gz";
    sha256 = "1kwpsqds51xmy3z3ddkam92hkl7arlzy9awhzsq62ysxcl91fb8m";
  };

  buildInputs = [ libev ocaml findlib ocaml_react ];

  propagatedBuildInputs = [ zed ocaml_lwt ];

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
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
