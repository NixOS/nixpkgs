{stdenv, buildOcaml, fetchurl, pcre, ocaml, findlib}:

buildOcaml {
  name = "pcre";
  version = "7.2.3";

  src = fetchurl {
    url = "https://github.com/mmottl/pcre-ocaml/releases/download/v7.2.3/pcre-ocaml-7.2.3.tar.gz";
    sha256 = "0rj6dw79px4sj2kq0iss2nzq3rnsn9wivvc0f44wa1mppr6njfb3";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [pcre];

  createFindlibDestdir = true;

  hasSharedObjects = true;

  configurePhase = "true";	# Skip configure phase

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/mmottl/pcre-ocaml;
    description = "An efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ z77z vbmithr ];
  };
}
