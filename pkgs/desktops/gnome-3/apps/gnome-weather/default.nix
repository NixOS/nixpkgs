{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gjs, gobject-introspection
, libgweather, meson, ninja, geoclue2, gnome-desktop, python3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-weather";
  version = "3.36.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "15ahfgqj0rz16y2bdxb7sa4b3b3larg8hn3b41pc5ddnwf9x63zi";
  };

  nativeBuildInputs = [ pkgconfig meson ninja wrapGAppsHook python3 ];
  buildInputs = [
    gtk3 gjs gobject-introspection gnome-desktop
    libgweather gnome3.adwaita-icon-theme geoclue2 gsettings-desktop-schemas
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
    updateScript = gnome3.updateScript {
      packageName = "gnome-weather";
      attrPath = "gnome3.gnome-weather";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Weather";
    description = "Access current weather conditions and forecasts";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
