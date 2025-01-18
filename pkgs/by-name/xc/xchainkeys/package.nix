{
  lib,
  stdenv,
  fetchurl,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "xchainkeys";
  version = "0.11";

  src = fetchurl {
    url = "http://henning-bekel.de/download/xchainkeys/xchainkeys-${version}.tar.gz";
    sha256 = "1rpqs7h5krral08vqxwb0imy33z17v5llvrg5hy8hkl2ap7ya0mn";
  };

  buildInputs = [ libX11 ];

  meta = with lib; {
    homepage = "http://henning-bekel.de/xchainkeys/";
    description = "Standalone X11 program to create chained key bindings";
    license = licenses.gpl3;
    platforms = platforms.unix;
    mainProgram = "xchainkeys";
  };
}
