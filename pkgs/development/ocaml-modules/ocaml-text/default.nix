{stdenv, fetchurl, libiconv, ocaml, findlib, ncurses}:

stdenv.mkDerivation {
  name = "ocaml-text-0.7.1";

  src = fetchurl {
    url = "https://github.com/vbmithr/ocaml-text/archive/0.7.1.tar.gz";
    sha256 = "0dn096q9gjfj7ibj237mb7lq0742a760zawka6i064qns727qwrg";
  };

  buildInputs = [ocaml findlib ncurses libiconv];

  configurePhase = "iconv_prefix=${libiconv} ocaml setup.ml -configure";

  createFindlibDestdir = true;


  meta = {
    homepage = "http://ocaml-text.forge.ocamlcore.org/";
    description = "A library for convenient text manipulation";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
