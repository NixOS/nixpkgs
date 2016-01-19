{ stdenv, fetchurl, texinfo, libXext, xextproto, libX11, xproto
, libXpm, libXt, libXcursor, alsaLib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc, xf86dgaproto, xf86miscproto
, xf86vidmodeproto, libXxf86vm, openal, mesa, kbproto, libjpeg, flac }:

stdenv.mkDerivation rec {
  name = "allegro-${version}";
  version = "5.0.11";

  src = fetchurl {
    url = "http://download.gna.org/allegro/allegro/${version}/${name}.tar.gz";
    sha256 = "0cd51qrh97jrr0xdmnivqgwljpmizg8pixsgvc4blqqlaz4i9zj9";
  };

  buildInputs = [
    texinfo libXext xextproto libX11 xproto libXpm libXt libXcursor
    alsaLib cmake zlib libpng libvorbis libXxf86dga libXxf86misc
    xf86dgaproto xf86miscproto xf86vidmodeproto libXxf86vm openal mesa
    kbproto libjpeg flac
  ];

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with stdenv.lib; {
    description = "A game programming library";
    homepage = http://liballeg.org/;
    license = licenses.zlib;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
