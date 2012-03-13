{ stdenv, fetchurl, pkgconfig, glib, gupnp_igd, gstreamer, gstPluginsBase }:

stdenv.mkDerivation rec {
  name = "libnice-0.1.1";
  
  src = fetchurl {
    url = "http://nice.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "0jcpb953jn7c3ng2vbkljybzh63x6mg4m6rjxj1s1iccm3fi6qki";
  };

  buildInputs = [ pkgconfig glib gupnp_igd gstreamer gstPluginsBase ];

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
