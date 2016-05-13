{ stdenv, fetchurl, pkgconfig, python, yasm
, gst-plugins-base, orc, bzip2
, withSystemLibav ? true, libav ? null
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# http://gstreamer.freedesktop.org/releases/1.6/ for more info.

assert withSystemLibav -> libav != null;

stdenv.mkDerivation rec {
  name = "gst-libav-1.8.0";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-libav/${name}.tar.xz";
    sha256 = "0719njp8aarhvn038pijq6dmsnli0zlg146hyfs3rsdffs4f472s";
  };

  outputs = [ "dev" "out" ];

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
