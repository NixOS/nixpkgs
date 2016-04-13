{ stdenv, fetchzip, libiconv, ocaml, findlib, ncurses }:

stdenv.mkDerivation rec {
  name = "ocaml-text-${version}";
  version = "0.8";

  src = fetchzip {
    url = "https://github.com/vbmithr/ocaml-text/archive/${version}.tar.gz";
    sha256 = "11jamdfn5s19a0yvl012q1xvdk1grkp4rkrn819imqrvdplqkn1y";
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
