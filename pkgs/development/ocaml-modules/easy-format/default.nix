{ stdenv, fetchzip, ocaml, findlib }:
let
  pname = "easy-format";
  version = "1.1.0";
in
stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchzip {
    url = "https://github.com/mjambon/${pname}/archive/v${version}.tar.gz";
    sha256 = "084blm13k5lakl5wq3qfxbd0l0bwblvk928v75xcxpaqwv426w5a";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A high-level and functional interface to the Format module of the OCaml standard library";
    homepage = "http://mjambon.com/${pname}.html";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
