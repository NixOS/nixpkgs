{ stdenv, fetchurl, substituteAll, pkgconfig, libxslt, ninja, libX11, gnome3, gtk3, glib
, gettext, libxml2, xkeyboard_config, isocodes, meson, wayland
, libseccomp, systemd, bubblewrap, gobject-introspection, gtk-doc, docbook_xsl, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-desktop";
  version = "3.36.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12f724inw3sv289xqprvwh8r3qw89z67m74j3hyhkbp1n7f99y9q";
  };

  nativeBuildInputs = [
    pkgconfig meson ninja gettext libxslt libxml2 gobject-introspection
    gtk-doc docbook_xsl glib
  ];
  buildInputs = [
    libX11 bubblewrap xkeyboard_config isocodes wayland
    gtk3 glib libseccomp systemd
  ];

  propagatedBuildInputs = [ gsettings-desktop-schemas ];

  patches = [
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Ddesktop_docs=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-desktop";
      attrPath = "gnome3.gnome-desktop";
    };
  };

  meta = with stdenv.lib; {
    description = "Library with common API for various GNOME modules";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
