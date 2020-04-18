{ stdenv, src, version }:
stdenv.mkDerivation rec {
  inherit src version;
  name = "ocaml-${version}+bs";
  configurePhase = ''
    ./configure -prefix $out
  '';
  buildPhase = ''
    make -j9 world.opt
  '';

  meta = with stdenv.lib; {
    branch = "4.06";
    platforms = platforms.all;
  };
}
