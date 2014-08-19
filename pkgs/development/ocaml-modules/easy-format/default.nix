{stdenv, fetchurl, ocaml, findlib}:
let
  pname = "easy-format";
  version = "1.0.2";
  webpage = "http://mjambon.com/${pname}.html";
in
stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://mjambon.com/releases/${pname}/${name}.tar.gz";
    sha256 = "07wlgprqvk92z0p2xzbnvh312ca6gvhy3xc6hxlqfawnnnin7rzi";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    description = "A high-level and functional interface to the Format module of the OCaml standard library";
    homepage = "${webpage}";
    license = "bsd";
  };
}


