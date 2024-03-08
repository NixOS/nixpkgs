{ lib
, stdenv
, fetchurl
, desktop-file-utils
, pkg-config
, gnome
, gtk4
, libadwaita
, wrapGAppsHook4
, gjs
, gobject-introspection
, libgweather
, meson
, ninja
, geoclue2
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-weather";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "MMAClwKIPcjYFg5t4dYRaHfNbCW8lQ1OSQKmq0Z7L6Q=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    pkg-config
    meson
    ninja
    wrapGAppsHook4
    python3
    gobject-introspection
    gjs
  ];

  buildInputs = [
    gtk4
    libadwaita
    gjs
    libgweather
    gnome.adwaita-icon-theme
    geoclue2
    gsettings-desktop-schemas
  ];

  postPatch = ''
    # The .service file is not wrapped with the correct environment
    # so misses GIR files when started. By re-pointing from the gjs
    # entry point to the wrapped binary we get back to a wrapped
    # binary.
    substituteInPlace "data/org.gnome.Weather.service.in" \
        --replace "Exec=@DATA_DIR@/@APP_ID@" \
                  "Exec=$out/bin/gnome-weather"

    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-weather";
      attrPath = "gnome.gnome-weather";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Weather";
    description = "Access current weather conditions and forecasts";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
