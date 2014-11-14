{stdenv, fetchurl, libiconvOrNull, ocaml, findlib, ncurses}:

stdenv.mkDerivation {
  name = "ocaml-text-0.6";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/937/ocaml-text-0.6.tar.gz;
    sha256 = "0j8gaak0ajnlmn8knvfygqwwzs7awjv5rfn5cbj6qxqbxhjd5m6g";
  };

  buildInputs = [ocaml findlib ncurses]
    ++ stdenv.lib.optional (libiconvOrNull != null) libiconvOrNull;

  configurePhase =
    (stdenv.lib.optionalString (libiconvOrNull != null) "iconv_prefix=${libiconvOrNull} ")
    + "ocaml setup.ml -configure";

  createFindlibDestdir = true;


  meta = {
    homepage = "http://ocaml-text.forge.ocamlcore.org/";
    description = "OCaml-Text is a library for dealing with ``text'', i.e. sequence of unicode characters, in a convenient way. ";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
  };
}
