{ stdenv, fetchFromGitHub, ocaml, ocamlbuild, cstruct, result, findlib, ocaml_oasis }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "ocaml-angstrom-${version}";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = "angstrom";
    rev    = "${version}";
    sha256 = "1x9pvy5vw98ns4pspj7i10pmgqyngn4v4cdlz5pbvwbrpwpn090q";
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
