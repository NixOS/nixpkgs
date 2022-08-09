{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, libxml2
, desktop-file-utils
, wrapGAppsHook4
, gtk4
, libadwaita
, libportal-gtk4
, gnome
, gnome-autoar
, glib-networking
, shared-mime-info
, libnotify
, libexif
, libseccomp
, librsvg
, tracker
, tracker-miners
, gexiv2
, libselinux
, libcloudproviders
, gdk-pixbuf
, substituteAll
, gnome-desktop
, gst_all_1
, gsettings-desktop-schemas
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "nautilus";
  version = "43.beta.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "vcNohRVfwJVzkkCy6VEAMvXZWCP5NL0bkpcIIQdWg1E=";
  };

  patches = [
    # Allow changing extension directory using environment variable.
    ./extension_dir.patch

    # Hardcode required paths.
    (substituteAll {
      src = ./fix-paths.patch;
      inherit tracker;
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gexiv2
    glib-networking
    gnome-desktop
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gtk4
    libadwaita
    libportal-gtk4
    libexif
    libnotify
    libseccomp
    libselinux
    gdk-pixbuf
    libcloudproviders
    shared-mime-info
    tracker
    tracker-miners
    gnome-autoar
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "The file manager for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Files";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
