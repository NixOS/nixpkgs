{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
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
  version = "3.34.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19zqwq4qyyncc5wq3xls0f7rsavnw741k336p2h7kx35p4kf41mv";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkgconfig
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

  patches = [
    ./extension_dir.patch
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "The file manager for GNOME";
    homepage = https://wiki.gnome.org/Apps/Files;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
