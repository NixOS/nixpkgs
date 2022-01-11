{ lib
, stdenv
, fetchurl
, pkg-config
, gnome
, gtk3
, libhandy
, wrapGAppsHook
, gjs
, gobject-introspection
, libgweather
, meson
, ninja
, geoclue2
, gnome-desktop
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-weather";
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1vidwq768xnrnr24jcfbpwjczz7vm5zmaiv41nb75q4p8avlwqg5";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    libhandy
    gjs
    gobject-introspection
    gnome-desktop
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
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
