{ stdenv, fetchurl, meson, ninja, pkgconfig
, python, yasm, gst-plugins-base, orc, bzip2
, gettext, withSystemLibav ? true, libav ? null
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# https://gstreamer.freedesktop.org/releases/1.6/ for more info.

assert withSystemLibav -> libav != null;

stdenv.mkDerivation rec {
  pname = "gst-libav";
  version = "1.16.0";

  meta = {
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-libav/${pname}-${version}.tar.xz";
    sha256 = "16ixqpfrr7plaaz14n3vagr2q5xbfkv7gpmcsyndrkx98f813b6z";
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

  mesonFlags = [
    # Enables all features, so that we know when new dependencies are necessary.
    "-Dauto_features=enabled"
  ];

}
