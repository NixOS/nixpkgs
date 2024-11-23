{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "udptunnel";
  version = "19";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/udptunnel/udptunnel-r${version}.tar.gz";
    sha256 = "1hkrn153rdyrp9g15z4d5dq44cqlnby2bfplp6z0g3862lnv7m3l";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/udptunnel
    cp udptunnel $out/bin
    cp README COPYING* $out/share/udptunnel
  '';

  meta = {
    homepage = "https://code.google.com/archive/p/udptunnel/";
    description = "Tunnels TCP over UDP packets";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "udptunnel";
  };
}
