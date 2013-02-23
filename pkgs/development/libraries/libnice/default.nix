{ stdenv, fetchurl, pkgconfig, glib, gupnp_igd, gstreamer, gst_plugins_base }:

stdenv.mkDerivation rec {
  name = "libnice-0.1.4";

  src = fetchurl {
    url = "http://nice.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0mxzr3y91hkjxdz1mzhxwi59la86hw2rzmd3y9c32801kkg1gra4";
  };

  buildInputs = [ pkgconfig glib gupnp_igd gstreamer gst_plugins_base ];

  meta = {
    homepage = http://nice.freedesktop.org/wiki/;
    description = "The GLib ICE implementation";
    longDescription = ''
      Libnice is an implementation of the IETF's Interactice Connectivity
      Establishment (ICE) standard (RFC 5245) and the Session Traversal
      Utilities for NAT (STUN) standard (RFC 5389).

      It provides a GLib-based library, libnice and a Glib-free library,
      libstun as well as GStreamer elements.'';
  };
}
