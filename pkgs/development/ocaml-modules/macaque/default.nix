{ lib, stdenv, fetchzip, ocaml, findlib, ocamlbuild, pgocaml, camlp4 }:

stdenv.mkDerivation {
  name = "ocaml-macaque-0.7.2";
  src = fetchzip {
    url = "https://github.com/ocsigen/macaque/archive/0.7.2.tar.gz";
    sha256 = "14i0a8cndzndjmlkyhf31r451q99cnkndgxcj0id4qjqhdl4bmjv";
  };

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ];
  propagatedBuildInputs = [ pgocaml ];

  createFindlibDestdir = true;

  meta = with lib; {
    description = "Macros for Caml Queries";
    homepage = "https://github.com/ocsigen/macaque";
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ vbgl ];
  };
}
