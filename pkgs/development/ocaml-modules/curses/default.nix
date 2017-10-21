{ stdenv, fetchurl, ocaml, findlib, ncurses }:

stdenv.mkDerivation rec {
  name = "ocaml-curses-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "http://ocaml.phauna.org/distfiles/ocaml-curses-${version}.ogunden1.tar.gz";
    sha256 = "0fxya4blx4zcp9hy8gxxm2z7aas7hfvwnjdlj9pmh0s5gijpwsll";
  };

  propagatedBuildInputs = [ ncurses ];

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  postPatch = ''
    substituteInPlace curses.ml --replace "pp gcc" "pp $CC"
  '';

  buildPhase = "make all opt";

  meta = with stdenv.lib; {
    description = "OCaml Bindings to curses/ncurses";
    homepage = https://opam.ocaml.org/packages/curses/curses.1.0.3/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = ocaml.meta.platforms or [];
    broken = true;
  };
}
