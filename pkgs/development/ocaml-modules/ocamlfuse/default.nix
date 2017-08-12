{ stdenv, fetchFromGitHub, ocaml, camlidl, fuse, findlib }:

stdenv.mkDerivation rec {
  name = "ocamlfuse-2.7-3";
  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    rev = "a085349685758668854499ce6c1fc00c83a5c23b";
    sha256 = "1pyml2ay5wab1blwpzrv1r6lnycm000jk6aar8i9fkdnh15sa6c3";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [camlidl fuse];
  configurePhase = '' ocaml setup.ml -configure --prefix $out '';
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";
  createFindlibDestdir = true;

  meta = {
    homepage = http://sourceforge.net/projects/ocamlfuse;
    license = stdenv.lib.licenses.gpl2;
    description = "ocaml binding for fuse";
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = stdenv.lib.platforms.linux;
  };
}
