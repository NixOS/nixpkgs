{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer, gstPluginsBase
, pygobject, gst_python, gupnp_igd }:

stdenv.mkDerivation rec {
  name = "farsight2-0.0.31";
  
  src = fetchurl {
    url = "http://farsight.freedesktop.org/releases/farsight2/${name}.tar.gz";
    sha256 = "16qz4x14rdycm4nrn5wx6k2y22fzrazsbmihrxdwafx9cyf23kjm";
  };

  buildInputs = [ libnice python pygobject gst_python gupnp_igd ];

  buildNativeInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gstPluginsBase ];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
  };
}
