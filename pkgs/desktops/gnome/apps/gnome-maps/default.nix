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
, libportal
, libshumate
, libsecret
, libsoup_3
, gsettings-desktop-schemas
, gjs
, libadwaita
, geocode-glib_2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-maps";
  version = "45.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-maps/${lib.versions.major finalAttrs.version}/gnome-maps-${finalAttrs.version}.tar.xz";
    hash = "sha256-6es3CnlxtPhC+qME0xpIXb2P+K7EKnZScvL8GnqAmPI=";
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
    libportal
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
      packageName = "gnome-maps";
      attrPath = "gnome.gnome-maps";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Maps";
    description = "A map application for GNOME 3";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
})
