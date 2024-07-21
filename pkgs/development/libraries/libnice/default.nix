{ lib, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, python3
, gobject-introspection
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, glib
, gupnp-igd
, gst_all_1
, gnutls
, graphviz
}:

stdenv.mkDerivation rec {
  pname = "libnice";
  version = "0.1.22";

  outputs = [ "bin" "out" "dev" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" ];

  src = fetchurl {
    url = "https://libnice.freedesktop.org/releases/${pname}-${version}.tar.gz";
    hash = "sha256-pfckzwnq5QxBp1FxQdidpKYeyerKMtpKAHP67VQXrX4=";
  };

  patches = [
    # Fix generating data
    # Note: upstream is not willing to merge our fix
    # https://gitlab.freedesktop.org/libnice/libnice/merge_requests/35#note_98871
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/libnice/libnice/commit/d470c4bf4f2449f7842df26ca1ce1efb63452bc6.patch";
      sha256 = "0z74vizf92flfw1m83p7yz824vfykmnm0xbnk748bnnyq186i6mg";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    gobject-introspection

    # documentation
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    graphviz
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gnutls
    gupnp-igd
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
    "-Dintrospection=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
  ];

  # Tests are flaky
  # see https://github.com/NixOS/nixpkgs/pull/53293#issuecomment-453739295
  doCheck = false;

  meta = with lib; {
    description = "GLib ICE implementation";
    longDescription = ''
      Libnice is an implementation of the IETF's Interactice Connectivity
      Establishment (ICE) standard (RFC 5245) and the Session Traversal
      Utilities for NAT (STUN) standard (RFC 5389).

      It provides a GLib-based library, libnice and a Glib-free library,
      libstun as well as GStreamer elements.'';
    homepage = "https://libnice.freedesktop.org/";
    platforms = platforms.unix;
    license = with licenses; [ lgpl21 mpl11 ];
  };
}
