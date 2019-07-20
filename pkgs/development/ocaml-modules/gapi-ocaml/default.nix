{ stdenv, fetchFromGitHub, buildDunePackage, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm }:

buildDunePackage rec {
  pname = "gapi-ocaml";
  version = "0.3.6";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qgsy51bhkpfgl5rdnjw4bqs5fbh2w4vwrfbl8y3lh1wrqmnwci4";
  };

  propagatedBuildInputs = [ ocurl cryptokit ocaml_extlib yojson ocamlnet xmlm ];

  meta = {
    description = "OCaml client for google services";
    homepage = http://gapi-ocaml.forge.ocamlcore.org;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
