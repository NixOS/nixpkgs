args: with args;

stdenv.mkDerivation rec {
  name = "gnonlin-0.10.10";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gnonlin/${name}.tar.gz"
      "mirror://gentoo/distfiles/${name}.tar.gz"
      ];
    sha256 = "041in2y0x3755hw29rhnyhsh216v2fl1q1p12m9faxiv2r52x83y";
  };

  buildInputs = [ gstPluginsBase gstreamer pkgconfig ];

  meta = {
    homepage = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
    description = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
    license = "GPLv2+";
  };
}
