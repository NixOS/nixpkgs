{ stdenv, fetchFromGitHub, ocaml, findlib, dune, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "gapi-ocaml is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "gapi-ocaml-${version}";
  version = "0.3.6";
  src = fetchFromGitHub {
    owner = "astrada";
    repo = "gapi-ocaml";
    rev = "v${version}";
    sha256 = "0qgsy51bhkpfgl5rdnjw4bqs5fbh2w4vwrfbl8y3lh1wrqmnwci4";
  };
  buildInputs = [ ocaml dune findlib ];
  propagatedBuildInputs = [ ocurl cryptokit ocaml_extlib yojson ocamlnet xmlm ];

  inherit (dune) installPhase;

  meta = {
    description = "OCaml client for google services";
    homepage = http://gapi-ocaml.forge.ocamlcore.org;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms or [];
  };
}
