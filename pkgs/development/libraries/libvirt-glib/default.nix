{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, gettext
, gtk-doc
, docbook-xsl-nons
, vala
, libcap_ng
, libvirt
, libxml2
}:

stdenv.mkDerivation rec {
  name = "libvirt-glib-4.0.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://libvirt.org/sources/glib/${name}.tar.xz";
    sha256 = "hCP3Bp2qR2MHMh0cEeLswoU0DNMsqfwFIHdihD7erL0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    gtk-doc
    docbook-xsl-nons
    vala
    gobject-introspection
  ];

  buildInputs = [
    libcap_ng
    libvirt
    libxml2
    gobject-introspection
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Library for working with virtual machines";
    longDescription = ''
      libvirt-glib wraps libvirt to provide a high-level object-oriented API better
      suited for glib-based applications, via three libraries:

      - libvirt-glib    - GLib main loop integration & misc helper APIs
      - libvirt-gconfig - GObjects for manipulating libvirt XML documents
      - libvirt-gobject - GObjects for managing libvirt objects
    '';
    homepage = "https://libvirt.org/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
