{ stdenv, fetchurl, ocaml, findlib }:

stdenv.mkDerivation {

  name = "ansiterminal-0.6.5";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1206/ANSITerminal-0.6.5.tar.gz";
    sha256 = "1j9kflv2i16vf9hy031cl6z8hv6791mjbhnd9bw07y1pswdlx1r6";
  };

  buildInputs = [ ocaml findlib ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";

  buildPhase = "ocaml setup.ml -build";

  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = "https://forge.ocamlcore.org/projects/ansiterminal";
    description = "A module allowing to use the colors and cursor movements on ANSI terminals";
    longDescription = ''
      ANSITerminal is a module allowing to use the colors and cursor
      movements on ANSI terminals. It also works on the windows shell (but
      this part is currently work in progress).
    '';
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
