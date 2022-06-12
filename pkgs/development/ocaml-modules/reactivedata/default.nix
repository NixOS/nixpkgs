{ lib, stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, react, opaline }:

if lib.versionOlder ocaml.version "4.04"
then throw "reactiveData is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-reactiveData";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "reactiveData";
    rev = version;
    sha256 = "sha256-YLkacIbjxZQ/ThgSxjTqviBYih6eW2GX5H7iybQDv1A=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild opaline ];
  propagatedBuildInputs = [ react ];

  strictDeps = true;

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
