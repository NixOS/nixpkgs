{ stdenv, pkgconfig, intltool, alsaLib, libpulseaudio, speex, gsm
, libopus, ffmpeg, libX11, libXv, libGLU, libGL, glew, libtheora, libvpx, SDL, libupnp
, ortp, libv4l, libpcap, srtp, fetchFromGitHub, cmake, bctoolbox, doxygen
, python, libXext, libmatroska, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "mediastreamer2";
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = pname;
    rev = version;
    sha256 = "02745bzl2r1jqvdqzyv94fjd4w92zr976la4c4nfvsy52waqah7j";
  };

  patches = [
    (fetchpatch {
      name = "allow-build-without-git.patch";
      url = "https://github.com/BelledonneCommunications/mediastreamer2/commit/de3a24b795d7a78e78eab6b974e7ec5abf2259ac.patch";
      sha256 = "1zqkrab42n4dha0knfsyj4q0wc229ma125gk9grj67ps7r7ipscy";
    })
    ./plugins_dir.patch
  ];

  nativeBuildInputs = [ pkgconfig intltool cmake doxygen python ];

  propagatedBuildInputs = [
    alsaLib libpulseaudio speex gsm libopus
    ffmpeg libX11 libXv libGLU libGL glew libtheora libvpx SDL libupnp
    ortp libv4l libpcap srtp bctoolbox libXext libmatroska
  ];

  NIX_CFLAGS_COMPILE = toString [
    "-DGIT_VERSION=\"v${version}\""
    "-Wno-error=deprecated-declarations"
    "-Wno-error=cast-function-type"
    "-Wno-error=stringop-truncation"
    "-Wno-error=stringop-overflow"
  ];
  NIX_LDFLAGS = "-lXext";

  meta = with stdenv.lib; {
    description = "A powerful and lightweight streaming engine specialized for voice/video telephony applications";
    homepage = http://www.linphone.org/technical-corner/mediastreamer2;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
