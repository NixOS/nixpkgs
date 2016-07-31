{ stdenv, fetchurl, libnice, pkgconfig, python, gstreamer, gst-plugins-base
, pygobject, gst-python, gupnp_igd }:

stdenv.mkDerivation rec {
  name = "farsight2-0.0.31";
  
  src = fetchurl {
    url = "http://farsight.freedesktop.org/releases/farsight2/${name}.tar.gz";
    sha256 = "16qz4x14rdycm4nrn5wx6k2y22fzrazsbmihrxdwafx9cyf23kjm";
  };

  buildInputs = [ libnice python pygobject gst-python gupnp_igd ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst-plugins-base ];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
  };
}
