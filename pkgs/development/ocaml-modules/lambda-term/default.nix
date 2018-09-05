{ stdenv, fetchurl, libev, ocaml, findlib, dune
, zed, lwt_log, lwt_react
}:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
  version = "1.13";
  name = "ocaml${ocaml.version}-lambda-term-${version}";

  src = fetchurl {
    url = "https://github.com/diml/lambda-term/archive/${version}.tar.gz";
    sha256 = "1hy5ryagqclgdm9lzh1qil5mrynlypv7mn6qm858hdcnmz9zzn0l";
  };

  buildInputs = [ libev ocaml findlib dune ];

  propagatedBuildInputs = [ zed lwt_log lwt_react ];

  buildPhase = "dune build -p lambda-term";

  inherit (dune) installPhase;

  hasSharedObjects = true;

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
