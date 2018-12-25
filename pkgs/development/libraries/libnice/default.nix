{ stdenv, fetchurl, pkgconfig, glib, gupnp-igd, gst_all_1, gnutls }:

stdenv.mkDerivation rec {
  name = "libnice-0.1.14";

  src = fetchurl {
    url = "https://nice.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "17404z0fr6z3k7s2pkyyh9xp5gv7yylgyxx01mpl7424bnlhn4my";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gst_all_1.gstreamer gst_all_1.gst-plugins-base gnutls ];
  propagatedBuildInputs = [ glib gupnp-igd ];

  doCheck = false; # fails with "fatal error: nice/agent.h: No such file or directory"

  meta = with stdenv.lib; {
    homepage = https://nice.freedesktop.org/wiki/;
    description = "The GLib ICE implementation";
    longDescription = ''
      Libnice is an implementation of the IETF's Interactice Connectivity
      Establishment (ICE) standard (RFC 5245) and the Session Traversal
      Utilities for NAT (STUN) standard (RFC 5389).

      It provides a GLib-based library, libnice and a Glib-free library,
      libstun as well as GStreamer elements.'';
    platforms = platforms.linux;
    license = with licenses; [ lgpl21 mpl11 ];
  };
}
