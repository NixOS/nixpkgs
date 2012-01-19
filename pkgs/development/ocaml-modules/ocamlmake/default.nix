{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ocaml-make-6.33.0";

  src = fetchurl {
    url = "http://www.ocaml.info/ocaml_sources/ocaml-make-6.33.0.tar.gz";
    sha256 = "3054303ba04e4bbbe038e08310fabc3e5a0e3899bbba33d9ac5ed7a1b9d1e05a";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = "cp OCamlMakefile $out";

  meta = {
    homepage = "http://www.ocaml.info/home/ocaml_sources.html";
    description = "Generic OCaml Makefile for GNU Make";
    license = "LGPL";
  };
}
