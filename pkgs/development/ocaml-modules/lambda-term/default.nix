{ stdenv, fetchurl, libev, ocaml, findlib, ocaml_lwt, ocaml_react, zed, camlp4 }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation rec {
  version = "1.8";
  name = "lambda-term-${version}";

  src = fetchurl {
    url = https://github.com/diml/lambda-term/archive/1.8.tar.gz;
    sha256 = "0hy11x48q5bbh9czjp0w756cyxzr2c6qcnfm5n9f0i1l4qljwpgc";
  };

  buildInputs = [ libev ocaml findlib ocaml_react ];

  propagatedBuildInputs = [ camlp4 zed ocaml_lwt ];

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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
