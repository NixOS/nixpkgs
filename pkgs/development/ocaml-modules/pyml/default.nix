{ stdenv, lib, fetchFromGitHub, ocaml, findlib, utop, python3, stdcompat, ncurses }:

stdenv.mkDerivation rec {
  pname = "pyml";
  version = "20211015";

  src = fetchFromGitHub {
    owner  = "thierry-martinez";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-GCO6KlRhJmADFjQ5QF4naMQBskF63yqnJnLnuQsagEk=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];
  buildInputs = [
    utop
    ncurses
  ];

  propagatedBuildInputs = [
    python3
    stdcompat
  ];

  strictDeps = true;

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
