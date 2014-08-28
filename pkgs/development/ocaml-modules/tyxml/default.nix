{stdenv, fetchurl, ocaml, findlib, ocaml_oasis}:

stdenv.mkDerivation {
  name = "tyxml-3.0.0";

  src = fetchurl {
    url = http://ocsigen.org/download/tyxml-3.0.0.tar.gz;
    sha256 = "0cvbmyg4g0lg4f23032cjlxqklisccbjgj47117wm6gva8xi7xa3";
    };

  buildInputs = [ocaml findlib ocaml_oasis];

  createFindlibDestdir = true;

  configurePhase = ''
  make setup-dev.exe
  ./setup-dev.exe -configure --prefix $out
  '';

  meta = {
    homepage = http://ocsigen.org/tyxml/;
    description = "Tyxml is a library that makes it almost impossible for your OCaml programs to generate wrong XML ouput, using static typing.";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
      ];
  };

}