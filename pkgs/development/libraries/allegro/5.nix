{ stdenv, fetchFromGitHub, fetchpatch, texinfo, libXext, xorgproto, libX11
, libXpm, libXt, libXcursor, alsaLib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc
, libXxf86vm, openal, libGLU, libGL, libjpeg, flac
, libXi, libXfixes, freetype, libopus, libtheora
, physfs, enet, pkgconfig, gtk2, pcre, libpulseaudio, libpthreadstubs
, libXdmcp
}:

stdenv.mkDerivation rec {
  pname = "allegro";
  version = "5.2.6.0";

  src = fetchFromGitHub {
    owner = "liballeg";
    repo = "allegro5";
    rev = version;
    sha256 = "1xbhvriyh10ka2j7jgjkpa6mlzp6av909hhr9sk317vjvf0z0mqz";
  };

  buildInputs = [
    texinfo libXext xorgproto libX11 libXpm libXt libXcursor
    alsaLib cmake zlib libpng libvorbis libXxf86dga libXxf86misc
    libXxf86vm openal libGLU libGL
    libjpeg flac
    libXi libXfixes
    enet libtheora freetype physfs libopus pkgconfig gtk2 pcre libXdmcp
    libpulseaudio libpthreadstubs
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
