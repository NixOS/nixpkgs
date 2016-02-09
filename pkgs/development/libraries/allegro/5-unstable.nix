{ stdenv, fetchurl, texinfo, libXext, xextproto, libX11, xproto
, libXpm, libXt, libXcursor, alsaLib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc, xf86dgaproto, xf86miscproto
, xf86vidmodeproto, libXxf86vm, openal, mesa, kbproto, libjpeg, flac
, inputproto, libXi, fixesproto, libXfixes }:

stdenv.mkDerivation rec {
  name = "allegro-${version}";
  version = "5.1.11";

  src = fetchurl {
    url = "http://download.gna.org/allegro/allegro-unstable/${version}/${name}.tar.gz";
    sha256 = "0zz07gdyc6xflpvkknwgzsyyyh9qiwd69j42rm9cw1ciwcsic1vs";
  };

  buildInputs = [
    texinfo libXext xextproto libX11 xproto libXpm libXt libXcursor
    alsaLib cmake zlib libpng libvorbis libXxf86dga libXxf86misc
    xf86dgaproto xf86miscproto xf86vidmodeproto libXxf86vm openal mesa
    kbproto libjpeg flac inputproto libXi fixesproto libXfixes
  ];

  patchPhase = ''
    sed -e 's@/XInput2.h@/XI2.h@g' -i CMakeLists.txt "src/"*.c
  '';

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with stdenv.lib; {
    description = "A game programming library";
    homepage = http://liballeg.org/;
    license = licenses.zlib;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
