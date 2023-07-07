{ lib, stdenv, fetchFromGitHub, fetchpatch, texinfo, libXext, xorgproto, libX11
, libXpm, libXt, libXcursor, alsa-lib, cmake, zlib, libpng, libvorbis
, libXxf86dga, libXxf86misc
, libXxf86vm, openal, libGLU, libGL, libjpeg, flac
, libXi, libXfixes, freetype, libopus, libtheora
, physfs, enet, pkg-config, gtk3, pcre, libpulseaudio, libpthreadstubs
, libXdmcp
}:

stdenv.mkDerivation rec {
  pname = "allegro";
  version = "5.2.8.0";

  src = fetchFromGitHub {
    owner = "liballeg";
    repo = "allegro5";
    rev = version;
    sha256 = "sha256-uNcaeTelFNfg+YjPYc7nK4TrFDxJsEuPhsF8x1cvIYQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    texinfo zlib libpng libvorbis openal libGLU libGL
    libjpeg flac enet libtheora freetype physfs libopus
    gtk3 pcre
  ] ++ lib.optionals stdenv.isLinux [
    libXext xorgproto libX11 libXpm libXt libXcursor alsa-lib
    libXxf86dga libXxf86misc libXxf86vm libXi libXfixes
    libXdmcp libpulseaudio libpthreadstubs
  ];

  postPatch = ''
    sed -e 's@/XInput2.h@/XI2.h@g' -i CMakeLists.txt "src/"*.c
    sed -e 's@Kernel/IOKit/hidsystem/IOHIDUsageTables.h@IOKit/hid/IOHIDUsageTables.h@g' -i include/allegro5/platform/alosx.h
    sed -e 's@OpenAL/@AL/@g' -i addons/audio/openal.c
  '';

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with lib; {
    description = "A game programming library";
    homepage = "https://liballeg.org/";
    license = licenses.zlib;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
