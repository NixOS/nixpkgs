{stdenv, fetchurl, pcre, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "6.2.5";
in

stdenv.mkDerivation {
  name = "ocaml-pcre-${version}";

  src = fetchurl {
    url = "http://www.ocaml.info/ocaml_sources/pcre-ocaml-${version}.tar.gz";
    sha256 = "f1774028a4525d22d1f4cf4ce0121c99d85a75aed7a498c3e8ab0f5e39888e47";
  };

  buildInputs = [pcre ocaml findlib];

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
