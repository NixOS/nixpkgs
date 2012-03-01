{stdenv, fetchurl}:

let

  version = "6.36.0";
  sha256 = "7c9a771d79bf945050dc7530957f4b61669976177818185e64c002cbfd75e3a2";

in stdenv.mkDerivation {
  name = "ocaml-make-${version}";

  src = fetchurl {
    url = "http://hg.ocaml.info/release/ocaml-make/archive/release-${version}.tar.bz2";
    inherit sha256;
  };

  installPhase = ''
    ensureDir "$out/include/"
    cp OCamlMakefile "$out/include/"
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.ocaml.info/home/ocaml_sources.html";
    description = "Generic OCaml Makefile for GNU Make";
    license = "LGPL";
  };
}
