{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "dypgen";
  version = "20120619-1";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://dypgen.free.fr/dypgen-20120619-1.tar.bz2";
    sha256 = "ecb53d6e469e9ec4d57ee6323ff498d45b78883ae13618492488e7c5151fdd97";
  };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;

  buildPhase = ''
    make
  '';

  makeFlags = "BINDIR=$(out)/bin  MANDIR=$(out)/usr/share/man/man1 DYPGENLIBDIR=$(out)/lib/ocaml/${ocaml_version}/site-lib";

  meta = {
    homepage = http://dypgen.free.fr;
    description = "Dypgen GLR self extensible parser generator";
    license = stdenv.lib.licenses.cecill-b;
    platforms = ocaml.meta.platforms or [];
  };
}
