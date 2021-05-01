{ lib
, stdenv
, fetchurl
, fetchpatch
, aalib
, alsaLib
, ffmpeg
, flac
, libGL
, libGLU
, libcaca
, libcdio
, libmng
, libmpcdec
, libpulseaudio
, libtheora
, libv4l
, libvorbis
, perl
, pkg-config
, speex
, vcdimager
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "xine-lib";
  version = "1.2.11";

  src = fetchurl {
    url = "mirror://sourceforge/xine/xine-lib-${version}.tar.xz";
    sha256 = "sha256-71GyHRDdoQRfp9cRvZFxz9rwpaKHQjO88W/98o7AcAU=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];
  buildInputs = [
    aalib
    alsaLib
    ffmpeg
    flac
    libGL
    libGLU
    libcaca
    libcdio
    libmng
    libmpcdec
    libpulseaudio
    libtheora
    libv4l
    libvorbis
    perl
    speex
    vcdimager
    zlib
  ] ++ (with xorg; [
    libX11
    libXext
    libXinerama
    libXv
    libxcb
  ]);

  patches = [
    # splitting path plugin
    (fetchpatch {
      name = "0001-fix-XINE_PLUGIN_PATH-splitting.patch";
      url = "https://sourceforge.net/p/xine/mailman/attachment/32394053-5e27-6558-f0c9-49e0da0bc3cc%40gmx.de/1/";
      sha256 = "sha256-LJedxrD8JWITDo9pnS9BCmy7wiPTyJyoQ1puX49tOls=";
    })
  ];

  NIX_LDFLAGS = "-lxcb-shm";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.xinehq.de/";
    description = "A high-performance, portable and reusable multimedia playback engine";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
