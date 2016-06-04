{stdenv, fetchurl, ocaml, findlib, ocaml_react, camlp4, opam}:

let
  ocamlVersion = stdenv.lib.getVersion ocaml;
in

assert stdenv.lib.versionAtLeast ocamlVersion "3.11";

stdenv.mkDerivation {
  name = "ocaml-reactiveData-0.2";
  src = fetchurl {
    url = https://github.com/ocsigen/reactiveData/archive/0.2.tar.gz;
    sha256 = "0rskcxnyjn8sxqnncdm6rh9wm99nha5m5sc83fywgzs64xfl43fq";
  };

  buildInputs = [ocaml findlib opam camlp4 ];
  propagatedBuildInputs = [ocaml_react];

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = ''
    opam-installer --script --prefix=$out reactiveData.install > install.sh
    sed -i s!lib/reactiveData!lib/ocaml/${ocamlVersion}/site-lib/reactiveData! install.sh
    sh install.sh
  '';

  meta = with stdenv.lib; {
    description = "An OCaml module for functional reactive programming (FRP) based on React";
    homepage = https://github.com/ocsigen/reactiveData;
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ vbgl ];
  };
}
