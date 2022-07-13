{ lib
, stdenv
, fetchurl
, substituteAll
, pkg-config
, libxslt
, ninja
, gnome
, gtk3
, gtk4
, glib
, gettext
, libxml2
, xkeyboard_config
, libxkbcommon
, isocodes
, meson
, wayland
, libseccomp
, systemd
, bubblewrap
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-desktop";
  version = "42.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-2lBBC48Z/X53WwDR/g26Z/xeEVHe0pkVjcJd2tw/qKk=";
  };

  patches = [
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    libxslt
    libxml2
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    glib
  ];

  buildInputs = [
    bubblewrap
    xkeyboard_config
    libxkbcommon # for xkbregistry
    isocodes
    wayland
    gtk3
    gtk4
    glib
    libseccomp
    systemd
  ];

  propagatedBuildInputs = [
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Ddesktop_docs=false"
    "-Ddate_in_gnome_version=false"
    "-Dgnome_distributor=NixOS"
  ];

  separateDebugInfo = stdenv.isLinux;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-desktop";
    };
  };

  meta = with lib; {
    description = "Library with common API for various GNOME modules";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-desktop";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
