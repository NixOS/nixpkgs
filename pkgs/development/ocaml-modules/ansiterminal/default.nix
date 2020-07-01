{ stdenv, fetchurl, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {

  version = "0.7";

  name = "ocaml${ocaml.version}-ansiterminal-${version}";

  src = fetchurl {
    url = "https://github.com/Chris00/ANSITerminal/releases/download/${version}/ANSITerminal-${version}.tar.gz";
    sha256 = "03pqfxvw9pa9720l8i5fgxky1qx70kw6wxbczd5i50xi668lh0i9";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";

  buildPhase = "ocaml setup.ml -build";

  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Chris00/ANSITerminal";
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
