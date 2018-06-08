{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, react, opaline }:

assert stdenv.lib.versionAtLeast ocaml.version "3.11";

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-reactiveData-0.2.1";
  src = fetchurl {
    url = https://github.com/ocsigen/reactiveData/archive/0.2.1.tar.gz;
    sha256 = "0wcs0z50nia1cpk8mh6i5qbc6sff9cc8x7s7q1q89d7m73bnv4vf";
  };

  buildInputs = [ ocaml findlib ocamlbuild opaline ];
  propagatedBuildInputs = [ react ];

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = "opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  meta = with stdenv.lib; {
    description = "An OCaml module for functional reactive programming (FRP) based on React";
    homepage = https://github.com/ocsigen/reactiveData;
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ vbgl ];
  };
}
