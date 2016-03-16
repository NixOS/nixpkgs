{stdenv, fetchurl, ocaml, findlib, ocaml_react, opam}:

let
  ocamlVersion = stdenv.lib.getVersion ocaml;
in

assert stdenv.lib.versionAtLeast ocamlVersion "3.11";

stdenv.mkDerivation {
  name = "ocaml-reactiveData-0.1";
  src = fetchurl {
    url = https://github.com/hhugo/reactiveData/archive/0.1.tar.gz;
    sha256 = "056y9in6j6rpggdf8apailvs1m30wxizpyyrj08xyfxgv91mhxgw";
  };

  buildInputs = [ocaml findlib opam];
  propagatedBuildInputs = [ocaml_react];

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = ''
    opam-installer --script --prefix=$out reactiveData.install > install.sh
    sed -i s!lib/reactiveData!lib/ocaml/${ocamlVersion}/site-lib/reactiveData! install.sh
    sh install.sh
  '';

  meta = with stdenv.lib; {
    description = "An OCaml module for functional reactive programming (FRP) based on React";
    homepage = https://github.com/hhugo/reactiveData;
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with maintainers; [ vbgl ];
  };
}
