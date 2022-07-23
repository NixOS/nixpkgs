{ stdenv
, lib
, fetchurl
, meson
, ninja
, gettext
, python3
, pkg-config
, gnome
, gtk3
, gobject-introspection
, gdk-pixbuf
, librest
, libgweather
, geoclue2
, wrapGAppsHook
, libchamplain
, libsecret
, libsoup
, gsettings-desktop-schemas
, gjs
, libhandy
, geocode-glib
}:

stdenv.mkDerivation rec {
  pname = "gnome-maps";
  version = "43.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-wFE9g8trmJ5HFZz4nHLnsIgejanl6kfI1+c2LY6uE5A=";
  };

  doCheck = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    geoclue2
    geocode-glib
    gjs
    gobject-introspection
    gsettings-desktop-schemas
    gtk3
    libchamplain
    libgweather
    libhandy
    librest
    libsecret
    libsoup
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

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
    platforms = platforms.linux;
  };
}
