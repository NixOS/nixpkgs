{stdenv, buildOcaml, fetchurl, pcre, ocaml, findlib}:

buildOcaml {
  name = "pcre";
  version = "7.1.1";

  src = fetchurl {
    url = https://github.com/mmottl/pcre-ocaml/releases/download/v7.1.1/pcre-ocaml-7.1.1.tar.gz;
    sha256 = "0nj4gb6hjjjmz5gnl9cjrh4w82rw8cvbwnk0hxhfgfd25p9k50n3";
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
