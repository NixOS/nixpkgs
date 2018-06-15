{ stdenv, fetchurl, meson, ninja, pkgconfig
, python, yasm, gst-plugins-base, orc, bzip2
, gettext, withSystemLibav ? true, libav ? null
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# https://gstreamer.freedesktop.org/releases/1.6/ for more info.

assert withSystemLibav -> libav != null;

stdenv.mkDerivation rec {
  name = "gst-libav-1.14.0";

  meta = {
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-libav/${name}.tar.xz";
    sha256 = "12gglx6rarnxbaj0h1wivlgkv467n1bz2bwjigplciq57r6ln4zv";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = with stdenv.lib;
    [ meson ninja gettext pkgconfig python ]
    ++ optional (!withSystemLibav) yasm
    ;

  buildInputs = with stdenv.lib;
    [ gst-plugins-base orc bzip2 ]
    ++ optional withSystemLibav libav
    ;
}
