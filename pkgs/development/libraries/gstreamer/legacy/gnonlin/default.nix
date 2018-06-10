{ stdenv, fetchurl, pkgconfig, gst-plugins-base, gstreamer }:

stdenv.mkDerivation rec {
  name = "gnonlin-0.10.17";

  src = fetchurl {
    urls = [
      "https://gstreamer.freedesktop.org/src/gnonlin/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "0dc9kvr6i7sh91cyhzlbx2bchwg84rfa4679ccppzjf0y65dv8p4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gst-plugins-base gstreamer ];

  meta = {
    homepage = https://gstreamer.freedesktop.org/modules/gnonlin.html;
    description = "Gstreamer Non-Linear Multimedia Editing Plugins";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
