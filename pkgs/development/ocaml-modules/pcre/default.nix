{stdenv, fetchurl, pcre, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "6.1.0";
in

stdenv.mkDerivation {
  name = "ocaml-pcre-${version}";

  src = fetchurl {
    url = "http://hg.ocaml.info/release/pcre-ocaml/archive/" +
          "release-${version}.tar.bz2";
    sha256 = "1lj9mzabi1crxwvb2ly1l10h4hlx0fw20nbnq76bbzzkzabjs4ll";
  };

  buildInputs = [pcre ocaml findlib];

  configurePhase = "true";	# Skip configure phase

  meta = {
    homepage = "http://www.ocaml.info/home/ocaml_sources.html#pcre-ocaml";
    description = "An efficient C-library for pattern matching with Perl-style regular expressions in OCaml";
    license = "LGPL";
  };
}
