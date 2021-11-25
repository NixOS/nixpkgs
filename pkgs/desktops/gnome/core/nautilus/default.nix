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
, libhandy
, libportal
, gnome
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
  version = "41.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "PmMwmIU3EaPpaxL+kiizIBgW5VSygj8WHn2QGoiAWC8=";
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
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gtk3
    libhandy
    libportal
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
