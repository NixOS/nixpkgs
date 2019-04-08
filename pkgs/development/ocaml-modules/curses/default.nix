{ stdenv, fetchurl, ocaml, findlib, ncurses }:

stdenv.mkDerivation rec {
  name = "ocaml-curses-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "http://ocaml.phauna.org/distfiles/ocaml-curses-${version}.ogunden1.tar.gz";
    sha256 = "08wq1r93lincdfzlriyc5nl2p4q7ca4h6ygzgp1nhkgd93pgk9v2";
  };

  propagatedBuildInputs = [ ncurses ];

  buildInputs = [ ocaml findlib ];

  # Fix build for recent ncurses versions
  NIX_CFLAGS_COMPILE = [ "-DNCURSES_INTERNALS=1" ];

  createFindlibDestdir = true;

  postPatch = ''
    substituteInPlace curses.ml --replace "pp gcc" "pp $CC"
  '';

  buildPhase = "make all opt";

  meta = with stdenv.lib; {
    description = "OCaml Bindings to curses/ncurses";
    homepage = https://opam.ocaml.org/packages/curses/curses.1.0.4/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
  };
}
