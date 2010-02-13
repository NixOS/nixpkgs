args: with args;

stdenv.mkDerivation rec {
  name = "gnonlin-0.10.14";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gnonlin/${name}.tar.gz"
      "mirror://gentoo/distfiles/${name}.tar.gz"
      ];
    sha256 = "10gp3hz9a6hrrmdaa3i2ry79fyr402il1qr0vpsd6ayn02gcj93w";
  };

  buildInputs = [ gstPluginsBase gstreamer pkgconfig ];

  meta = {
    homepage = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
    description = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
    license = "GPLv2+";
  };
}
