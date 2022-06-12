{ lib
, stdenv
, fetchurl
, pkg-config
, gnome
, gtk4
, libadwaita
, wrapGAppsHook
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
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "V57mkdhT5bs/9Q6Me0P4Wundfls6ZJ4CwlSi2bgHtGU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk4
    libadwaita
    gjs
    gobject-introspection
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
    platforms = platforms.linux;
  };
}
