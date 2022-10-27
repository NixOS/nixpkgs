{ lib
, stdenv
, fetchpatch
, fetchurl
, meson
, ninja
, pkg-config
, gi-docgen
, docbook-xsl-nons
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
, webp-pixbuf-loader
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
, gnome-user-share
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "nautilus";
  version = "43.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "PPVPrAqKvuCQ4VVBf3sW9j6grAwmTvT1RXSvNFgBqRE=";
  };

  patches = [
    # Switch to GTK 4 settings schema to avoid crash when GTK 3 did not manage to contaminate environment.
    # https://gitlab.gnome.org/GNOME/nautilus/-/merge_requests/1013
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/nautilus/-/commit/96d542a0d84da4ad6915a7727642490a5c433d4a.patch";
      sha256 = "BO/0ifRwSTDe7RV+DI3CPZg+UQezk0tbM+UidgoJRQM=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/nautilus/-/commit/52b4daf4396fd3b21755b3a0d1fbf85c3831c6b1.patch";
      sha256 = "+8KCw2HZUi9UgOEUBNp4kbwqOI1qz6i0Q/wvzqTb8OA=";
    })

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
    gi-docgen
    docbook-xsl-nons
    wrapGAppsHook4
  ];

  buildInputs = [
    gexiv2
    glib-networking
    gnome-desktop
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    gnome-user-share
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

  mesonFlags = [
    "-Ddocs=true"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${webp-pixbuf-loader}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
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
