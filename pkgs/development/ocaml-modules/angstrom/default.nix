{ stdenv, fetchFromGitHub, ocaml, ocamlbuild, cstruct, result, findlib, ocaml_oasis }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "ocaml-angstrom-${version}";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = "angstrom";
    rev    = "${version}";
    sha256 = "019s3jwhnswa914bgj1fa6q67k0bl2ahqdaqfnavcbyii8763kh2";
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
