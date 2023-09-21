{ stdenv
, lib
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, wrapGAppsHook4
, itstool
, desktop-file-utils
, vala
, gobject-introspection
, libxml2
, gtk4
, glib
, gsound
, sound-theme-freedesktop
, gsettings-desktop-schemas
, gnome-desktop
, geocode-glib_2
, gnome
, gdk-pixbuf
, geoclue2
, libgweather
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "gnome-clocks";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "F9epc2XLjxoCOh1491AfM1Mhf6dXfXOv59DKHjtPODg=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook4
    desktop-file-utils
    libxml2
    gobject-introspection # for finding vapi files
    # error: Package `...' not found in specified Vala API directories or GObject-Introspection GIR directories
    # TODO: the vala setuphook should look for vala filess in targetOffset instead of hostOffset
    gsound
  ];

  buildInputs = [
    gtk4
    glib
    gsettings-desktop-schemas
    gdk-pixbuf
    gnome-desktop
    geocode-glib_2
    geoclue2
    libgweather
    gsound
    libadwaita
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Fallback sound theme
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
    )
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-clocks";
      attrPath = "gnome.gnome-clocks";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Clocks";
    description = "Clock application designed for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
