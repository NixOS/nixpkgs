{ stdenv, fetchurl, libnice, pkgconfig, python2Packages, gstreamer, gst_plugins_base
, gst-python, gupnp_igd }:

let
  inherit (python2Packages) python pygobject2;
in stdenv.mkDerivation rec {
  name = "farsight2-0.0.31";
  
  src = fetchurl {
    url = "http://farsight.freedesktop.org/releases/farsight2/${name}.tar.gz";
    sha256 = "16qz4x14rdycm4nrn5wx6k2y22fzrazsbmihrxdwafx9cyf23kjm";
  };

  buildInputs = [ libnice python pygobject2 gst-python gupnp_igd ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst_plugins_base ];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
    platforms = stdenv.lib.platforms.linux;
  };
}
