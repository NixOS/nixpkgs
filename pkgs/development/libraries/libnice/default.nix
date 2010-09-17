{stdenv, fetchurl, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "libnice-0.0.10";
  
  src = fetchurl {
    url = http://nice.freedesktop.org/releases/libnice-0.0.10.tar.gz;
    sha256 = "04r7syk67ihw8gzy83f603kmwvqv2dpd1mrfzpk4p72vjqrqidl6";
  };

  buildInputs = [ pkgconfig glib ];

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
