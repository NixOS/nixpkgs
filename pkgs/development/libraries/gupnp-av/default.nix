{ stdenv, fetchurl, gupnp, pkgconfig }:

stdenv.mkDerivation rec {
  name = "gupnp-av-${version}";
  majorVersion = "0.12";
  version = "${majorVersion}.4";
  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-av/${majorVersion}/gupnp-av-${version}.tar.xz";
    sha256 = "0nvsvpiyfslz54j4hjh2gsdjkbi2qj2f4k0aw8s7f05kibprr2jl";
  };
  
  buildInputs = [ gupnp pkgconfig ];

  meta = {
    homepage = http://gupnp.org/;
    description = "GUPnP-AV is a collection of helpers for building AV (audio/video) applications using GUPnP.";
    longDescription = "GUPnP implements the UPnP specification: resource announcement and discovery, description, control, event notification, and presentation (GUPnP includes basic web server functionality through libsoup). GUPnP does not include helpers for construction or control of specific standardized resources (e.g. MediaServer); this is left for higher level libraries utilizing the GUPnP framework.";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}