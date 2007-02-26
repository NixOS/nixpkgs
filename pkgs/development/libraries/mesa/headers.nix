{stdenv, mesaSrc}:

stdenv.mkDerivation {
  name = "mesa-headers-6.5.2"; # !!! keep up-to-date
  buildCommand = "
    unpackFile ${mesaSrc}
    ensureDir $out/include
    cp -prvd Mesa-*/include/GL $out/include/
  ";
}