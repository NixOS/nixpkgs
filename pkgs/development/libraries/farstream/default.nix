{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer, gst_plugins_base
, pygobject, gst_python, gupnp_igd
, gst_plugins_good, gst_plugins_bad, gst_ffmpeg
}:

stdenv.mkDerivation rec {
  name = "farstream-0.1.2";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/farstream/releases/farstream/${name}.tar.gz";
    sha256 = "1nbkbvq959f70zhr03fwdibhs0sbf1k7zmbz9w99vda7gdcl0nps";
  };

  buildInputs = [ libnice python pygobject gupnp_igd ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst_plugins_base gst_python 
    gst_plugins_good gst_plugins_bad gst_ffmpeg
    ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/Farstream;
    description = "Audio/Video Communications Framework formely known as farsight";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
