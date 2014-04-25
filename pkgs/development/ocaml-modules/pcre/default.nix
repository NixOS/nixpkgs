{stdenv, fetchurl, pcre, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-pcre-7.0.4";

  src = fetchurl {
    url = https://bitbucket.org/mmottl/pcre-ocaml/downloads/pcre-ocaml-7.0.4.tar.gz;
    sha256 = "0h2qlza7jkzgrglw1k0fydpbil0dgpv526kxyyd1apdbyzhb0mpw";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [pcre];

  createFindlibDestdir = true;

  configurePhase = "true";	# Skip configure phase

  meta = with stdenv.lib; {
    homepage = "https://bitbucket.org/mmottl/pcre-ocaml";
    description = "An efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [ z77z vbmithr ];
  };
}
