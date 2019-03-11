{ stdenv, fetchurl, fetchpatch, meson, ninja, pkgconfig, python3, gobject-introspection, gtk-doc, docbook_xsl, docbook_xml_dtd_412, glib, gupnp-igd, gst_all_1, gnutls }:

stdenv.mkDerivation rec {
  name = "libnice-0.1.15";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://nice.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1nl7fn07f4i513s9c1s1ic3rki8rm2d000wsf6f4157mb0zhya7p";
  };

  patches = [
    # Fix generating data
    # Note: upstream is not willing to merge our fix
    # https://gitlab.freedesktop.org/libnice/libnice/merge_requests/35#note_98871
    (fetchpatch {
      url = https://gitlab.freedesktop.org/libnice/libnice/commit/d470c4bf4f2449f7842df26ca1ce1efb63452bc6.patch;
      sha256 = "0z74vizf92flfw1m83p7yz824vfykmnm0xbnk748bnnyq186i6mg";
    })

    # Fix test-different-number-streams
    # https://gitlab.freedesktop.org/libnice/libnice/merge_requests/36
    (fetchpatch {
      url = https://gitlab.freedesktop.org/libnice/libnice/commit/a38c2adfc4bed2a69dc02568417f0926dd555b9a.patch;
      sha256 = "1rh4z4iknrimmm3b3v8ln8vl3dsqi91g4vf0dl85348kvnf0sv6z";
    })
    # Fix test-gstreamer
    # https://gitlab.freedesktop.org/libnice/libnice/merge_requests/35
    (fetchpatch {
      url = https://gitlab.freedesktop.org/libnice/libnice/commit/02de1fa1956105b09d9db4fd6331452b0ff0b8a2.patch;
      sha256 = "12dymq1v20wj5n1cway4n3y8fkra1ffnpj5w7pbz38i612b82qw0";
    })
  ];

  nativeBuildInputs = [ meson ninja pkgconfig python3 gobject-introspection gtk-doc docbook_xsl docbook_xml_dtd_412 ];
  buildInputs = [ gst_all_1.gstreamer gst_all_1.gst-plugins-base gnutls ];
  propagatedBuildInputs = [ glib gupnp-igd ];

  mesonFlags = [
    "-Dgupnp=enabled"
    "-Dgstreamer=enabled"
    "-Dignored-network-interface-prefix=enabled"
    "-Dexamples=enabled"
    "-Dtests=enabled"
    "-Dgtk_doc=enabled"
    "-Dintrospection=enabled"
  ];

  # TODO; see #53293 etc.
  #doCheck = true;

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
