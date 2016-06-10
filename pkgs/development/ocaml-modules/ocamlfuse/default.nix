{ stdenv, fetchgit, ocaml, camlidl, fuse, findlib }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation rec {
  name = "ocamlfuse-2.7-1";
  src = fetchgit {
    url = "https://github.com/astrada/ocamlfuse";
    rev = "c436c16dbf458bc69b1166b08baf9ec0d6f9042d";
    sha256 = "0br9x3vsbg87sar5g6yi3xfszn5icy4fv71waarccc2dr79pvakz";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [camlidl fuse];
  configurePhase = '' ocaml setup.ml -configure --prefix $out '';
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";
  createFindlibDestdir = true;

  meta = {
    homepage = "http://sourceforge.net/projects/ocamlfuse";
    license = stdenv.lib.licenses.gpl2;
    description = "ocaml binding for fuse";
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = stdenv.lib.platforms.linux;
  };
}
