{ lib, stdenv, fetchFromGitHub, ocaml, findlib, ncurses }:

stdenv.mkDerivation rec {
  pname = "ocaml-curses";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "mbacarella";
    repo = "curses";
    rev = version;
    sha256 = "0yy3wf8i7jgvzdc40bni7mvpkvclq97cgb5fw265mrjj0iqpkqpd";
  };

  strictDeps = true;

  propagatedBuildInputs = [ ncurses ];

  nativeBuildInputs = [ ocaml findlib ];

  # Fix build for recent ncurses versions
  env.NIX_CFLAGS_COMPILE = "-DNCURSES_INTERNALS=1";

  createFindlibDestdir = true;

  postPatch = ''
    substituteInPlace curses.ml --replace "pp gcc" "pp $CC"
  '';

  buildPhase = "make all opt";

  meta = with lib; {
    description = "OCaml Bindings to curses/ncurses";
    homepage = "https://github.com/mbacarella/curses";
    license = licenses.lgpl21Plus;
    changelog = "https://github.com/mbacarella/curses/raw/${version}/CHANGES";
    maintainers = [ ];
    inherit (ocaml.meta) platforms;
  };
}
