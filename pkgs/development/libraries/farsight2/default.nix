{ stdenv, fetchurl, libnice, pkgconfig, pythonPackages, gstreamer, gst_plugins_base
, gst_python, gupnp_igd }:

let
  inherit (pythonPackages) python pygobject2;
in stdenv.mkDerivation rec {
  name = "farsight2-0.0.31";
  
  src = fetchurl {
    url = "http://farsight.freedesktop.org/releases/farsight2/${name}.tar.gz";
    sha256 = "16qz4x14rdycm4nrn5wx6k2y22fzrazsbmihrxdwafx9cyf23kjm";
  };

  buildInputs = [ libnice python pygobject2 gst_python gupnp_igd ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gstreamer gst_plugins_base ];

  meta = {
    homepage = http://farsight.freedesktop.org/wiki/;
    description = "Audio/Video Communications Framework";
    platforms = stdenv.lib.platforms.linux;
  };
}
