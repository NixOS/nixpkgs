{stdenv, fetchurl, pcre, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "6.2.5";
in

stdenv.mkDerivation {
  name = "ocaml-pcre-${version}";

  src = fetchurl {
    url = "http://www.ocaml.info/ocaml_sources/pcre-ocaml-${version}.tar.gz";
    sha256 = "ff41006901f5b2d06a455ec48230eb34375f2eeb8240c341e81ebba0342ee331";
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
