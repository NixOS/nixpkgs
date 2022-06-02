{ lib, stdenv, src, version }:
stdenv.mkDerivation rec {
  inherit src version;
  pname = "ocaml-bs";
  configurePhase = ''
    ./configure -prefix $out
  '';
  buildPhase = ''
    make -j9 world.opt
  '';

  meta = with lib; {
    branch = "4.06";
    platforms = platforms.all;
  };
}
