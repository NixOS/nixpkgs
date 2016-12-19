{ stdenv, fetchurl, texinfo, libXext, xextproto, libX11, xproto
, libXpm, libXt, libXcursor, alsaLib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc, xf86dgaproto, xf86miscproto
, xf86vidmodeproto, libXxf86vm, openal, mesa, kbproto, libjpeg, flac
, inputproto, libXi, fixesproto, libXfixes, freetype, libopus, libtheora
, physfs, enet, pkgconfig, gtk2, pcre, libpulseaudio, libpthreadstubs
, libXdmcp
}:

stdenv.mkDerivation rec {
  name = "allegro-${version}";
  version = "5.2.1.1";

  src = fetchurl {
    url = "http://download.gna.org/allegro/allegro/${version}/${name}.tar.gz";
    sha256 = "0waalic7lyaf6i33nikmkc29bndci5c5090c4ra2vmy67cqdzndm";
  };

  buildInputs = [
    texinfo libXext xextproto libX11 xproto libXpm libXt libXcursor
    alsaLib cmake zlib libpng libvorbis libXxf86dga libXxf86misc
    xf86dgaproto xf86miscproto xf86vidmodeproto libXxf86vm openal mesa
    kbproto libjpeg flac
    inputproto libXi fixesproto libXfixes
    enet libtheora freetype physfs libopus pkgconfig gtk2 pcre libXdmcp
    libpulseaudio libpthreadstubs
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
