{ stdenv
, lib
, fetchFromGitHub
, ocaml
, findlib
}:

stdenv.mkDerivation rec {
  pname = "grain_dypgen";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "grain-lang";
    repo = "dypgen";
    rev = version;
    sha256 = "vTt1hCItFEskiotIbRaHjGz3aAbpaLnPZaXAReOuuPI=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/usr/share/man/man1"
    "DYPGENLIBDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/grain-lang/dypgen";
    description = "Dypgen GLR self extensible parser generator";
    license = lib.licenses.cecill-b;
    platforms = ocaml.meta.platforms or [];
  };
}
