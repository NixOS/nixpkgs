{ stdenv, fetchzip, ocaml, findlib }:

let version = "3.0"; in

stdenv.mkDerivation {
  name = "ocaml-dolog-${version}";
  src = fetchzip {
    url = "https://github.com/UnixJunkie/dolog/archive/v${version}.tar.gz";
    sha256 = "0gx2s4509vkkkaikl2yp7k5x7bqv45s1y1vsy408d8rakd7yl1zb";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = https://github.com/UnixJunkie/dolog;
    description = "Minimalistic lazy logger in OCaml";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
