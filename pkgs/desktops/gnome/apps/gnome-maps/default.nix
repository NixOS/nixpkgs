{ stdenv
, lib
, fetchurl
, meson
, ninja
, gettext
, python3
, pkg-config
, gnome
, glib
, gtk4
, gobject-introspection
, gdk-pixbuf
, librest_1_0
, libgweather
, geoclue2
, wrapGAppsHook4
, desktop-file-utils
, libshumate
, libsecret
, libsoup_3
, gsettings-desktop-schemas
, gjs
, libadwaita
, geocode-glib_2
}:

stdenv.mkDerivation rec {
  pname = "gnome-maps";
  version = "44.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-3admgmWnCVKWDElRnPv7+jV2gyb8W4CyYX8U/7LJuHM=";
  };

  doCheck = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gobject-introspection
    # For post install script
    desktop-file-utils
    glib
    gtk4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    geoclue2
    geocode-glib_2
    gjs
    gsettings-desktop-schemas
    gtk4
    libshumate
    libgweather
    libadwaita
    librest_1_0
    libsecret
    libsoup_3
  ];

  postPatch = ''
    # The .service file isn't wrapped with the correct environment
    # so misses GIR files when started. By re-pointing from the gjs
    # entry point to the wrapped binary we get back to a wrapped
    # binary.
    substituteInPlace "data/org.gnome.Maps.service.in" \
        --replace "Exec=@pkgdatadir@/@app-id@" \
                  "Exec=$out/bin/gnome-maps"
  '';

  preCheck = ''
    # “time.js” included by “timeTest” and “translationsTest” depends on “org.gnome.desktop.interface” schema.
    export XDG_DATA_DIRS="${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:$XDG_DATA_DIRS"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Maps";
    description = "A map application for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
