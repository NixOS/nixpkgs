{ lib, stdenv, fetchurl, pkg-config, glib, librest, gnome-online-accounts
, gnome, libsoup, json-glib, gobject-introspection
, gtk-doc, pkgs, docbook-xsl-nons, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  pname = "gfbgraph";
  version = "0.2.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0yck7dwvjk16a52nafjpi0a39rxwmg0w833brj45acz76lgkjrb0";
  };

  nativeBuildInputs = [
    pkg-config gobject-introspection gtk-doc
    docbook-xsl-nons autoconf automake libtool
  ];
  buildInputs = [ glib gnome-online-accounts ];
  propagatedBuildInputs = [ libsoup json-glib librest ];

  configureFlags = [ "--enable-introspection" "--enable-gtk-doc" ];

  prePatch = ''
    patchShebangs autogen.sh
    substituteInPlace autogen.sh \
      --replace "which" "${pkgs.which}/bin/which"
  '';

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GFBGraph";
    description = "GLib/GObject wrapper for the Facebook Graph API";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
