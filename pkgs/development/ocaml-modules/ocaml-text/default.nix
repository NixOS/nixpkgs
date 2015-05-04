{stdenv, fetchurl, libiconv, ocaml, findlib, ncurses}:

stdenv.mkDerivation {
  name = "ocaml-text-0.6";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/937/ocaml-text-0.6.tar.gz;
    sha256 = "0j8gaak0ajnlmn8knvfygqwwzs7awjv5rfn5cbj6qxqbxhjd5m6g";
  };

  buildInputs = [ocaml findlib ncurses libiconv];

  configurePhase = "iconv_prefix=${libiconv} ocaml setup.ml -configure";

  createFindlibDestdir = true;


  meta = {
    homepage = "http://ocaml-text.forge.ocamlcore.org/";
    description = "A library for convenient text manipulation";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
  };
}
