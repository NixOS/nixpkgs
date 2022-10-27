{ lib
, stdenv
, fetchurl
, fetchpatch
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
  pname = "libvirt-glib";
  version = "4.0.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://libvirt.org/sources/glib/${pname}-${version}.tar.xz";
    sha256 = "hCP3Bp2qR2MHMh0cEeLswoU0DNMsqfwFIHdihD7erL0=";
  };

  patches = [
    # Fix build with GLib 2.70
    (fetchpatch {
      url = "https://gitlab.com/libvirt/libvirt-glib/-/commit/9a34c4ea55e0246c34896e48b8ecd637bc559ac7.patch";
      sha256 = "UU70uTi55EzPMuLYVKRzpVcd3WogeAtWAWEC2hWlR7k=";
    })
  ];

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

  buildInputs = (lib.optionals stdenv.isLinux [
    libcap_ng
  ]) ++ [
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
    platforms = platforms.unix;
  };
}
