{stdenv, fetchurl,
  libtool, libjpeg, openssl, libX11, libXdamage, xproto, damageproto, 
  xextproto, libXext, fixesproto, libXfixes, xineramaproto, libXinerama, 
  libXrandr, randrproto, libXtst, zlib, libgcrypt, autoreconfHook
  , systemd, pkgconfig, libpng
}:

assert stdenv.isLinux;

let
  s = # Generated upstream information
  rec {
    baseName="libvncserver";
    version="0.9.11";
    name="${baseName}-${version}";
    url="https://github.com/LibVNC/libvncserver/archive/LibVNCServer-${version}.tar.gz";
    sha256="15189n09r1pg2nqrpgxqrcvad89cdcrca9gx6qhm6akjf81n6g8r";
  };
  buildInputs = [
    libtool libjpeg openssl libX11 libXdamage xproto damageproto
    xextproto libXext fixesproto libXfixes xineramaproto libXinerama
    libXrandr randrproto libXtst zlib libgcrypt autoreconfHook systemd
    pkgconfig libpng
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preConfigure = ''
    sed -e 's@/usr/include/linux@${stdenv.cc.libc}/include/linux@g' -i configure
  '';
  meta = {
    inherit (s) version;
    description =  "VNC server library";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
