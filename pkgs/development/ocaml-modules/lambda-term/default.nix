{ stdenv, buildOcaml, fetchurl, libev, ocaml, findlib, jbuilder, zed, lwt_react }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

buildOcaml rec {
  version = "1.12.0";
  name = "lambda-term";

  src = fetchurl {
    url = "https://github.com/diml/lambda-term/archive/${version}.tar.gz";
    sha256 = "129m5jb015rqm6k3k25m1i2217vhz26n8sa7z113vjv4gs0bcd3d";
  };

  buildInputs = [ libev ocaml findlib jbuilder ];

  propagatedBuildInputs = [ zed lwt_react ];

  buildPhase = "jbuilder build -p lambda-term";

  installPhase = ''
    ${jbuilder.installPhase}
    mv $out/lib/ocaml/${ocaml.version}/site-lib/{stubslibs,lambda-term}/dlllambda_term_stubs.so
  '';

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
