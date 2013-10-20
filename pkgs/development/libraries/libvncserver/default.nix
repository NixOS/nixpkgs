{stdenv, fetchurl,
  libtool, libjpeg, openssl, libX11, libXdamage, xproto, damageproto, 
  xextproto, libXext, fixesproto, libXfixes, xineramaproto, libXinerama, 
  libXrandr, randrproto, libXtst, zlib
}:
let
  s = # Generated upstream information
  rec {
    baseName="libvncserver";
    version="0.9.9";
    name="${baseName}-${version}";
    hash="1y83z31wbjivbxs60kj8a8mmjmdkgxlvr2x15yz95yy24lshs1ng";
    url="mirror://sourceforge/project/libvncserver/libvncserver/0.9.9/LibVNCServer-0.9.9.tar.gz";
    sha256="1y83z31wbjivbxs60kj8a8mmjmdkgxlvr2x15yz95yy24lshs1ng";
  };
  buildInputs = [
    libtool libjpeg openssl libX11 libXdamage xproto damageproto
    xextproto libXext fixesproto libXfixes xineramaproto libXinerama
    libXrandr randrproto libXtst zlib
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preConfigure = ''
    sed -e 's@/usr/include/linux@${stdenv.gcc.libc}/include/linux@g' -i configure
  '';
  meta = {
    inherit (s) version;
    description =  "VNC server library";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
