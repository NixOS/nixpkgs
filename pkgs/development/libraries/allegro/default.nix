{ stdenv, fetchurl, texinfo, libXext, xextproto, libX11, xproto
, libXpm, libXt, libXcursor, alsaLib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc, xf86dgaproto, xf86miscproto
, xf86vidmodeproto, libXxf86vm, openal, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "allegro-${version}";
  version="4.4.2";

  src = fetchurl {
    url = "http://download.gna.org/allegro/allegro/${version}/${name}.tar.gz";
    sha256 = "1p0ghkmpc4kwij1z9rzxfv7adnpy4ayi0ifahlns1bdzgmbyf88v";
  };

  patches = [
    ./nix-unstable-sandbox-fix.patch
  ];

  buildInputs = [
    texinfo libXext xextproto libX11 xproto libXpm libXt libXcursor
    alsaLib cmake zlib libpng libvorbis libXxf86dga libXxf86misc
    xf86dgaproto xf86miscproto xf86vidmodeproto libXxf86vm openal libGLU_combined
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with stdenv.lib; {
    description = "A game programming library";
    homepage = http://liballeg.org/;
    license = licenses.free; # giftware
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
