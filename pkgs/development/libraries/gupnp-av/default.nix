{ stdenv, fetchurl, pkgconfig, gupnp, glib, libxml2 }:

stdenv.mkDerivation rec {
  name = "gupnp-av-${version}";
  majorVersion = "0.12";
  version = "${majorVersion}.7";

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-av/${majorVersion}/${name}.tar.xz";
    sha256 = "35e775bc4f7801d65dcb710905a6b8420ce751a239b5651e6d830615dc906ea8";
  };
  
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gupnp glib libxml2 ];

  meta = {
    homepage = http://gupnp.org/;
    description = "A collection of helpers for building AV (audio/video) applications using GUPnP";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
