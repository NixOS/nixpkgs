{ stdenv, fetchzip, ocaml, findlib }:

let version = "1.0"; in

stdenv.mkDerivation {
  name = "ocaml-dolog-${version}";
  src = fetchzip {
    url = "https://github.com/UnixJunkie/dolog/archive/v${version}.tar.gz";
    sha256 = "1yy3a0h9xn5mv8q38yx5jgavj2hgfw42mdnrzixl25pqx7idvcmf";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = https://github.com/UnixJunkie/dolog;
    description = "Minimalistic lazy logger in OCaml";
    platforms = ocaml.meta.platforms;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
