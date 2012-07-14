{stdenv, fetchurl, pcre, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-pcre-6.2.5";

  src = fetchurl {
    url = https://bitbucket.org/mmottl/pcre-ocaml/downloads/pcre-ocaml-6.2.5.tar.gz;
    sha256 = "0iwfi0wmw3xbx31ri96pmrsmmn4r3h9f0k6gyk8j4pajlhl40xzi";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [pcre];

  createFindlibDestdir = true;

  configurePhase = "true";	# Skip configure phase

  meta = {
    homepage = "http://www.ocaml.info/home/ocaml_sources.html";
    description = "An efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
