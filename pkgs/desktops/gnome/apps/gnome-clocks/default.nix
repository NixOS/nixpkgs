{ lib, stdenv
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, wrapGAppsHook
, itstool
, desktop-file-utils
, vala
, gobject-introspection
, libxml2
, gtk3
, glib
, gsound
, sound-theme-freedesktop
, gsettings-desktop-schemas
, adwaita-icon-theme
, gnome-desktop
, geocode-glib
, gnome
, gdk-pixbuf
, geoclue2
, libgweather
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "gnome-clocks";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "02d3jg46sn8d9gd4dsaly22gg5vkbz2gpq4pmwpvncb4rsqk7sn2";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    gettext
    itstool
    wrapGAppsHook
    desktop-file-utils
    libxml2
    gobject-introspection # for finding vapi files
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    gdk-pixbuf
    adwaita-icon-theme
    gnome-desktop
    geocode-glib
    geoclue2
    libgweather
    gsound
    libhandy
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
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
