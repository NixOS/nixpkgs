{ stdenv, fetchurl, pkgconfig, python, yasm
, gst-plugins-base, orc, bzip2
, withSystemLibav ? true, libav ? null
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# https://gstreamer.freedesktop.org/releases/1.6/ for more info.

assert withSystemLibav -> libav != null;

stdenv.mkDerivation rec {
  name = "gst-libav-1.12.3";

  meta = {
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-libav/${name}.tar.xz";
    sha256 = "0l4nc6ikdx49l7bdrk3bd9p3pzry8a328r22zg48gyzpnv5ghph1";
  };

  outputs = [ "out" "dev" ];

  configureFlags = stdenv.lib.optionalString withSystemLibav
    "--with-system-libav";

  nativeBuildInputs = with stdenv.lib;
    [ pkgconfig python ]
    ++ optional (!withSystemLibav) yasm
    ;

  buildInputs = with stdenv.lib;
    [ gst-plugins-base orc bzip2 ]
    ++ optional withSystemLibav libav
    ;
}
