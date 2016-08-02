{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer, gst-plugins-base
, pygobject, gst-python, gupnp_igd
, gst-plugins-good, gst-plugins-bad, gst-libav
}:

stdenv.mkDerivation rec {
  name = "farstream-0.2.4";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/farstream/releases/farstream/${name}.tar.gz";
    sha256 = "0c5vlyiwb799wpby4g9vffiy0nf09gy2cr84ksfy3jwzsxf5n38j";
  };

  buildInputs = [ libnice python pygobject gupnp_igd libnice ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base gst-python
    gst-plugins-good gst-plugins-bad gst-libav
    ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/Farstream;
    description = "Audio/Video Communications Framework formely known as farsight";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
