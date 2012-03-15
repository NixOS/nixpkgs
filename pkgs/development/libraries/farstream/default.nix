{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer, gst_plugins_base
, pygobject, gst_python, gupnp_igd }:

stdenv.mkDerivation rec {
  name = "farstream-0.1.1";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/farstream/releases/farstream/${name}.tar.gz";
    sha256 = "0lmdz7ijpgrc0zbr11jp3msvz44p809scx2m56bk5l5x1xrs123v";
  };

  buildInputs = [ libnice python pygobject gst_python gupnp_igd ];

  buildNativeInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst_plugins_base ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/Farstream;
    description = "Audio/Video Communications Framework formely known as farsight";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
