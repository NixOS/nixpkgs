{stdenv, lib, fetchurl, ocaml, findlib}:

let
  pname = "dypgen";
in

if lib.versionAtLeast ocaml.version "4.06"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "20120619-1";

  src = fetchurl {
    url = "http://dypgen.free.fr/dypgen-20120619-1.tar.bz2";
    sha256 = "ecb53d6e469e9ec4d57ee6323ff498d45b78883ae13618492488e7c5151fdd97";
  };

  nativeBuildInputs = [ ocaml findlib ];

  strictDeps = true;

  createFindlibDestdir = true;

  buildPhase = ''
    make
  '';

  makeFlags = [ "BINDIR=$(out)/bin" "MANDIR=$(out)/usr/share/man/man1" "DYPGENLIBDIR=$(out)/lib/ocaml/${ocaml.version}/site-lib" ];

  meta = {
    homepage = "http://dypgen.free.fr";
    description = "Dypgen GLR self extensible parser generator";
    license = lib.licenses.cecill-b;
    platforms = ocaml.meta.platforms or [];
  };
}
