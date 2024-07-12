{ lib
, alsa-lib
, cmake
, enet
, fetchFromGitHub
, flac
, freetype
, gtk3
, libGL
, libGLU
, libjpeg
, libopus
, libpng
, libpthreadstubs
, libpulseaudio
, libtheora
, libvorbis
, libwebp
, libX11
, libXcursor
, libXdmcp
, libXext
, libXfixes
, libXi
, libXpm
, libXt
, libXxf86dga
, libXxf86misc
, libXxf86vm
, openal
, pcre
, physfs
, pkg-config
, stdenv
, texinfo
, xorgproto
, zlib
}:

stdenv.mkDerivation rec {
  pname = "allegro";
  version = "5.2.9.1";

  src = fetchFromGitHub {
    owner = "liballeg";
    repo = "allegro5";
    rev = version;
    sha256 = "sha256-n2OCmZmAqeXjtnCTqJgQ5q4j8/lnPfH+5tpWKIFKle0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    enet
    flac
    freetype
    gtk3
    libGL
    libGLU
    libjpeg
    libopus
    libpng
    libtheora
    libvorbis
    libwebp
    openal
    pcre
    physfs
    texinfo
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libpthreadstubs
    libpulseaudio
    libX11
    libXcursor
    libXdmcp
    libXext
    libXfixes
    libXi
    libXpm
    libXt
    libXxf86dga
    libXxf86misc
    libXxf86vm
    xorgproto
  ];

  postPatch = ''
    sed -e 's@/XInput2.h@/XI2.h@g' -i CMakeLists.txt "src/"*.c
    sed -e 's@Kernel/IOKit/hidsystem/IOHIDUsageTables.h@IOKit/hid/IOHIDUsageTables.h@g' -i include/allegro5/platform/alosx.h
    sed -e 's@OpenAL/@AL/@g' -i addons/audio/openal.c
  '';

  cmakeFlags = [ "-DCMAKE_SKIP_RPATH=ON" ];

  meta = with lib; {
    description = "Game programming library";
    homepage = "https://liballeg.org/";
    license = licenses.zlib;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
