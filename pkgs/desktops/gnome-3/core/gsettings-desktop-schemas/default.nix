{ stdenv, fetchurl, pkgconfig, intltool, glib, gobject-introspection
  # just for passthru
, gnome3 }:

stdenv.mkDerivation rec {
  name = "gsettings-desktop-schemas-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gsettings-desktop-schemas/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0bshwm49cd01ighsxqlbqn10q0ch71ff99gcrx8pr2gyky2ad3pq";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gsettings-desktop-schemas"; };
  };

  preInstall = ''
    mkdir -p $out/share/gsettings-schemas/${name}/glib-2.0/schemas
    cat - > $out/share/gsettings-schemas/${name}/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      [org.gnome.desktop.background]
      picture-uri='''

      [org.gnome.desktop.screensaver]
      picture-uri='''
    EOF
  '';

  buildInputs = [ glib gobject-introspection ];

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
