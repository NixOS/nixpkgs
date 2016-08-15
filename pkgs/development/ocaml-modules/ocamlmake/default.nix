{stdenv, fetchurl}:

let

  version = "6.37.0";
  sha256 = "99ff58080ed154cc4bd70f915fe4760dffb026a1c0447caa0b3bdb982b24b0a8";

in stdenv.mkDerivation {
  name = "ocaml-make-${version}";

  src = fetchurl {
    url = "http://bitbucket.org/mmottl/ocaml-makefile/downloads/ocaml-makefile-${version}.tar.gz";
    inherit sha256;
  };

  installPhase = ''
    mkdir -p "$out/include/"
    cp OCamlMakefile "$out/include/"
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.ocaml.info/home/ocaml_sources.html";
    description = "Generic OCaml Makefile for GNU Make";
    license = "LGPL";
    platforms = stdenv.lib.platforms.unix;
  };
}
