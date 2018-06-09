{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opaline }:

let
  pname = "cmdliner";
in

assert stdenv.lib.versionAtLeast ocaml.version "3.12";

stdenv.mkDerivation rec {

  name = "ocaml-${pname}-${version}";
  version = "0.9.8";

  src = fetchurl {
    url = "http://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "0hdxlkgiwjml9dpaa80282a8350if7mc1m6yz2mrd7gci3fszykx";
  };

  unpackCmd = "tar xjf $src";
  nativeBuildInputs = [ ocamlbuild opaline ];
  buildInputs = [ ocaml findlib ];

  configurePhase = "ocaml pkg/git.ml";
  buildPhase     = "ocaml pkg/build.ml native=true native-dynlink=true";
  installPhase   = "opaline -libdir $OCAMLFIND_DESTDIR";

  meta = with stdenv.lib; {
    homepage = http://erratique.ch/software/cmdliner;
    description = "An OCaml module for the declarative definition of command line interfaces";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
  };
}
