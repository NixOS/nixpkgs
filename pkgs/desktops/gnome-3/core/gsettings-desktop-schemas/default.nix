{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection
  # just for passthru
, gnome3, gtk3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  preInstall = ''
    mkdir -p $out/share/gsettings-schemas/${name}/glib-2.0/schemas
    cat - > $out/share/gsettings-schemas/${name}/glib-2.0/schemas/remove-backgrounds.gschema.override <<- EOF
      [org.gnome.desktop.background]
      picture-uri='''

      [org.gnome.desktop.screensaver]
      picture-uri='''
    EOF
  '';

  buildInputs = [ glib gobjectIntrospection ];

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
