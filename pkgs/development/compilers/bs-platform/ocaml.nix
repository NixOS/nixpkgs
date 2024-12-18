{ lib, stdenv, src, version }:
stdenv.mkDerivation rec {
  inherit src version;
  pname = "ocaml-bs";
  configurePhase = ''
    ./configure -prefix $out
  '';

  # Workaround ocaml-4.06 limitation of duplicate definitions.
  #   ld: libcamlrun.a(minor_gc.o):/build/ocaml/byterun/caml/major_gc.h:67: multiple definition of
  #     `caml_major_ring'; libcamlrun.a(stacks.o):/build/ocaml/byterun/caml/major_gc.h:67: first defined here
  # Match -fcommon workaround in ocaml-4.06 itself.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildPhase = ''
    make -j9 world.opt
  '';

  meta = with lib; {
    branch = "4.06";
    platforms = platforms.all;
  };
}
