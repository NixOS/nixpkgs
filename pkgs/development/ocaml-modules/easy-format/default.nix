{ lib, stdenv, fetchzip, ocaml, findlib }:
let
  pname = "easy-format";
  version = "1.2.0";
in
stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchzip {
    url = "https://github.com/mjambon/${pname}/archive/v${version}.tar.gz";
    sha256 = "00ga7mrlycjc99gzp3bgx6iwhf7i6j8856f8xzrf1yas7zwzgzm9";
  };

  nativeBuildInputs = [ ocaml findlib ];
  strictDeps = true;

  createFindlibDestdir = true;

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "A high-level and functional interface to the Format module of the OCaml standard library";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
