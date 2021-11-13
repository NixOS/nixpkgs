{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, react, opaline }:

if !lib.versionAtLeast ocaml.version "4.04"
then throw "reactiveData is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-reactiveData";
  version = "0.2.2";

  src = fetchurl {
    url = "https://github.com/ocsigen/reactiveData/archive/${version}.tar.gz";
    sha256 = "0jzagyp4zla28wykvcgqwd8df71ir0vb4s8akp02cfacd5v86sng";
  };

  buildInputs = [ ocaml findlib ocamlbuild opaline ];
  propagatedBuildInputs = [ react ];

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = "opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  meta = with lib; {
    description = "An OCaml module for functional reactive programming (FRP) based on React";
    homepage = "https://github.com/ocsigen/reactiveData";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [ ];
    maintainers = with maintainers; [ vbgl ];
  };
}
