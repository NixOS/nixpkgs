{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook, gjs, gobject-introspection
, libgweather, intltool, itstool, geoclue2, gnome-desktop }:

stdenv.mkDerivation rec {
  name = "gnome-weather-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-weather/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "965cc0d1b4d4e53c06d494db96f0b124d232af5c0e731ca900edd10f77a74c78";
  };

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 gjs gobject-introspection gnome-desktop
    libgweather gnome3.defaultIconTheme geoclue2 gnome3.gsettings-desktop-schemas
  ];

  # The .service file isn't wrapped with the correct environment
  # so misses GIR files when started. By re-pointing from the gjs
  # entry point to the wrapped binary we get back to a wrapped
  # binary.
  preConfigure = ''
    substituteInPlace "data/org.gnome.Weather.Application.service.in" \
        --replace "Exec=@pkgdatadir@/@PACKAGE_NAME@.Application" \
                  "Exec=$out/bin/gnome-weather"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-weather";
      attrPath = "gnome3.gnome-weather";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Weather;
    description = "Access current weather conditions and forecasts";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
