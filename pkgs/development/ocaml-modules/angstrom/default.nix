{ stdenv, fetchFromGitHub, ocaml, ocamlbuild, cstruct, result, findlib, ocaml_oasis }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.03"
  then {
    version = "0.5.1";
    sha256 = "0rm79xyszy9aqvflcc13y9xiya82z31fzmr3b3hx91pmqviymhgc";
  } else {
    version = "0.4.0";
    sha256 = "019s3jwhnswa914bgj1fa6q67k0bl2ahqdaqfnavcbyii8763kh2";
  };
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "ocaml-angstrom-${version}";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = "angstrom";
    rev    = "${version}";
    inherit (param) sha256;
  };

  createFindlibDestdir = true;

  buildInputs = [ ocaml ocaml_oasis findlib ocamlbuild ];
  propagatedBuildInputs = [ result cstruct ];

  meta = {
    homepage = https://github.com/inhabitedtype/angstrom;
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
    inherit (ocaml.meta) platforms;
  };
}
