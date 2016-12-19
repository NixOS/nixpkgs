{ stdenv, fetchurl, pkgconfig, glib, gupnp_igd, gst_all_1 }:

stdenv.mkDerivation rec {
  name = "libnice-0.1.13";

  src = fetchurl {
    url = "http://nice.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1q8rhklbz1zla67r4mw0f7v3m5b32maj0prnr0kshcz97fgjs4b1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gst_all_1.gstreamer gst_all_1.gst-plugins-base ];
  propagatedBuildInputs = [ glib gupnp_igd ];

  meta = {
    homepage = http://nice.freedesktop.org/wiki/;
    description = "The GLib ICE implementation";
    longDescription = ''
      Libnice is an implementation of the IETF's Interactice Connectivity
      Establishment (ICE) standard (RFC 5245) and the Session Traversal
      Utilities for NAT (STUN) standard (RFC 5389).

      It provides a GLib-based library, libnice and a Glib-free library,
      libstun as well as GStreamer elements.'';
    platforms = stdenv.lib.platforms.linux;
  };
}
