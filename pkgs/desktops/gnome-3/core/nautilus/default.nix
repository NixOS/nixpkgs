{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, libxml2
, desktop-file-utils
, python3
, wrapGAppsHook
, gtk3
, gnome3
, gnome-autoar
, glib-networking
, shared-mime-info
, libnotify
, libexif
, libseccomp
, exempi
, librsvg
, tracker
, tracker-miners
, gexiv2
, libselinux
, gdk-pixbuf
, substituteAll
, gnome-desktop
, gst_all_1
, gsettings-desktop-schemas
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "nautilus";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19ln84d6s05h6cvx3c500bg5pvkz4k6p6ykmr2201rblq9afp76h";
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
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    exempi
    gexiv2
    glib-networking
    gnome-desktop
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gtk3
    libexif
    libnotify
    libseccomp
    libselinux
    shared-mime-info
    tracker
    tracker-miners
  ];

  propagatedBuildInputs = [
    gnome-autoar
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
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
