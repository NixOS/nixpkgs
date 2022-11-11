{ lib
, stdenv
, fetchurl
, fetchpatch
, aalib
, alsa-lib
, autoconf
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
, ncurses
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

  patches = [
    # Fix build with libcaca 0.99.beta20 ; remove for xine-lib 1.2.12
    (fetchpatch {
      name = "xine-lib-libcaca-0.99.beta20-fix.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/209ae10d59d29c13633b75aa327cf937f3ff0725/trunk/010-xine-lib-libcaca-0.99.beta20-fix.patch";
      sha256 = "088141x1yp84y09x3s01v21yzas2bwavxz9v30z5hyq6c3syrmgr";
    })
    # Fix build with ffmpeg 5.0 ; remove for xine-lib 1.2.12
    (fetchpatch {
      name = "xine-lib-ffmpeg-5.0-fix.patch";
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/209ae10d59d29c13633b75aa327cf937f3ff0725/trunk/020-xine-lib-ffmpeg-5.0-fix.patch";
      sha256 = "15ff15bqxq1nqqazfbmfq6swrdjr2raxyq7hx6k0r61izhf0g8ld";
    })
  ];

  nativeBuildInputs = [
    autoconf
    pkg-config
    perl
  ];
  buildInputs = [
    aalib
    alsa-lib
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
    ncurses
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

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lxcb-shm";


  meta = with lib; {
    homepage = "http://xine.sourceforge.net/";
    description = "A high-performance, portable and reusable multimedia playback engine";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
