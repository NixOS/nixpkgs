{ stdenv, lib, fetchFromGitHub, ocaml, findlib, utop, python3, stdcompat, ncurses }:

stdenv.mkDerivation rec {
  pname = "pyml";
  version = "20210226";

  src = fetchFromGitHub {
    owner  = "thierry-martinez";
    repo   = pname;
    rev    = version;
    sha256 = "15xk6bgdzsf04d6wdjpr3s1ci2g7d7qnbq3102avkz179d5n62h7";
  };

  buildInputs = [
    ocaml
    findlib
    utop
    ncurses
  ];

  propagatedBuildInputs = [
    python3
    stdcompat
  ];

  buildPhase = ''
    make all pymltop pymlutop PREFIX=$out
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    make install PREFIX=$out
    runHook postInstall
  '';

  doCheck = true;

  meta = {
    description = "OCaml bindings for Python";
    license = lib.licenses.bsd2;
  };
}
