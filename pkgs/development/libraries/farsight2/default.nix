{ stdenv, fetchurl, libnice, pkgconfig, python, gst_all
, pygobject, gupnp_igd }:

stdenv.mkDerivation rec {
  name = "farsight2-0.0.31";
  
  src = fetchurl {
    url = "http://farsight.freedesktop.org/releases/farsight2/${name}.tar.gz";
    sha256 = "16qz4x14rdycm4nrn5wx6k2y22fzrazsbmihrxdwafx9cyf23kjm";
  };

  buildInputs = [ libnice python pygobject gst_all.gst-python gupnp_igd ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = with gst_all; [ gstreamer gst-plugins-base ];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
  };
}
