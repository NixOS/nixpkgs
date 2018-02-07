{ stdenv, fetchurl, pkgconfig, gupnp, glib, libxml2 }:

stdenv.mkDerivation rec {
  name = "gupnp-av-${version}";
  majorVersion = "0.12";
  version = "${majorVersion}.10";

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-av/${majorVersion}/${name}.tar.xz";
    sha256 = "0nmq6wlbfsssanv3jgv2z0nhfkv8vzfr3gq5qa8svryvvn2fyf40";
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
