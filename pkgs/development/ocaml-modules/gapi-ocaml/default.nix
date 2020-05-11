{ stdenv, fetchFromGitHub, buildDunePackage
, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm
}:

buildDunePackage rec {
  pname = "gapi-ocaml";
  version = "0.3.19";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = pname;
    rev = "v${version}";
    sha256 = "04arif1p1vj5yr24cwicj70b7yx17hrgf4pl47vqg8ngcrdh71v9";
  };

  propagatedBuildInputs = [ ocurl cryptokit ocaml_extlib ocamlnet yojson ];
  buildInputs = [ xmlm ];

  meta = {
    description = "OCaml client for google services";
    homepage = "http://gapi-ocaml.forge.ocamlcore.org";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
