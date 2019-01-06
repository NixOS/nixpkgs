{ stdenv, fetchFromGitHub, fetchpatch, texinfo, libXext, xorgproto, libX11
, libXpm, libXt, libXcursor, alsaLib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc
, libXxf86vm, openal, libGLU_combined, libjpeg, flac
, libXi, libXfixes, freetype, libopus, libtheora
, physfs, enet, pkgconfig, gtk2, pcre, libpulseaudio, libpthreadstubs
, libXdmcp
}:

stdenv.mkDerivation rec {
  name = "allegro-${version}";
  version = "5.2.4.0";

  src = fetchFromGitHub {
    owner = "liballeg";
    repo = "allegro5";
    rev = version;
    sha256 = "01y3hirn5b08f188nnhb2cbqj4vzysr7l2qpz2208srv8arzmj2d";
  };

  buildInputs = [
    texinfo libXext xorgproto libX11 libXpm libXt libXcursor
    alsaLib cmake zlib libpng libvorbis libXxf86dga libXxf86misc
    libXxf86vm openal libGLU_combined
    libjpeg flac
    libXi libXfixes
    enet libtheora freetype physfs libopus pkgconfig gtk2 pcre libXdmcp
    libpulseaudio libpthreadstubs
  ];

  patches = [
   # fix compilation with mesa 18.2.5
   (fetchpatch {
     url = "https://github.com/liballeg/allegro5/commit/a40d30e21802ecf5c9382cf34af9b01bd3781e47.patch";
     sha256 = "1f1xlj5y2vr6wzmcz04s8kxn8cfdwrg9kjlnvpz9dix1z3qjnd4m";
   })
  ];

  postPatch = ''
    sed -e 's@/XInput2.h@/XI2.h@g' -i CMakeLists.txt "src/"*.c
  '';

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with stdenv.lib; {
    description = "A game programming library";
    homepage = https://liballeg.org/;
    license = licenses.zlib;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
