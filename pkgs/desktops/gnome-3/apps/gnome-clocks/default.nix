{ stdenv
, fetchurl
, meson
, ninja
, gettext
, pkgconfig
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
, gnome3
, gdk-pixbuf
, geoclue2
, libgweather
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "gnome-clocks";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0f24g76ax59qnms1rjfyf1i0sa84nadgbr0r6m26p90w1w2wnmnr";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkgconfig
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
    updateScript = gnome3.updateScript {
      packageName = "gnome-clocks";
      attrPath = "gnome3.gnome-clocks";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Clocks";
    description = "Clock application designed for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
