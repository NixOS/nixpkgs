{ stdenv, fetchFromGitHub, ocaml, camlidl, fuse, findlib }:

stdenv.mkDerivation rec {
  name = "ocamlfuse-${version}";
  version = "2.7.1_cvs5";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    rev = "v${version}";
    sha256 = "01ayw2hzpxan95kncbxh9isj9g149cs8scq3xim1vy8bz085wb0m";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [camlidl fuse];
  configurePhase = '' ocaml setup.ml -configure --prefix $out '';
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";
  createFindlibDestdir = true;

  meta = {
    homepage = https://sourceforge.net/projects/ocamlfuse;
    description = "OCaml bindings for FUSE";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
