{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, opam, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm }:

stdenv.mkDerivation rec {
  name = "gapi-ocaml-${version}";
  version = "0.3.6";
  src = fetchFromGitHub {
    owner = "astrada";
    repo = "gapi-ocaml";
    rev = "v${version}";
    sha256 = "0qgsy51bhkpfgl5rdnjw4bqs5fbh2w4vwrfbl8y3lh1wrqmnwci4";
  };
  buildInputs = [ ocaml jbuilder findlib ];
  propagatedBuildInputs = [ ocurl cryptokit ocaml_extlib yojson ocamlnet xmlm ];

  installPhase = "${opam}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR";

  createFindlibDestdir = true;

  meta = {
    description = "OCaml client for google services";
    homepage = http://gapi-ocaml.forge.ocamlcore.org;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms or [];
  };
}
