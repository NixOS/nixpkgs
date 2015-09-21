{ stdenv, fetchzip, ocaml, findlib }:

let version = "1.1"; in

stdenv.mkDerivation {
  name = "ocaml-dolog-${version}";
  src = fetchzip {
    url = "https://github.com/UnixJunkie/dolog/archive/v${version}.tar.gz";
    sha256 = "093lmprb1v2ran3pyymcdq80xnsgdz7h76g764xsy97dba5ik40n";
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
