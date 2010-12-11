{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.8.1";
in

stdenv.mkDerivation {
  name = "camomile-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/camomile/camomile-${version}.tar.bz2";
    sha256 = "1r84y7wl10zkjmp8qqq2bcmll23qmfczlnykm74hxkig8ksm0g6a";
  };

  buildInputs = [ocaml findlib];

  #dontAddPrefix = true;

  meta = {
    homepage = http://camomile.sourceforge.net/;
    description = "A comprehensive Unicode library for OCaml";
    license = "LGPL";
  };
}
