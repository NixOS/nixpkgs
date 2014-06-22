{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer, gst-plugins-base
, pygobject, gst-python, gupnp_igd
, gst-plugins-good, gst-plugins-bad, gst-ffmpeg
}:

stdenv.mkDerivation rec {
  name = "farstream-0.1.2";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/farstream/releases/farstream/${name}.tar.gz";
    sha256 = "1nbkbvq959f70zhr03fwdibhs0sbf1k7zmbz9w99vda7gdcl0nps";
  };

  buildInputs = [ libnice python pygobject gupnp_igd libnice ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base gst-python
    gst-plugins-good gst-plugins-bad gst-ffmpeg
    ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/Farstream;
    description = "Audio/Video Communications Framework formely known as farsight";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
