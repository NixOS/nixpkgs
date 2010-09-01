args: with args;

stdenv.mkDerivation rec {
  name = "gnonlin-0.10.15";

  src = fetchurl {
    urls = [
      "http://gstreamer.freedesktop.org/src/gnonlin/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1yz0i3vzpadz5axwdb310bypl4rm1xy2n6mgajja0w2z6afnrfv0";
  };

  buildInputs = [ gstPluginsBase gstreamer pkgconfig ];

  meta = {
    homepage = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
    description = "http://gstreamer.freedesktop.org/modules/gnonlin.html";
    license = "GPLv2+";
  };
}
