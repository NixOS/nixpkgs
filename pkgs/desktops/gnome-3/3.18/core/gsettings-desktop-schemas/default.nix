{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection
  # just for passthru
, gnome3, gtk3, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  postPatch = ''
    for file in "background" "screensaver"; do
      substituteInPlace "schemas/org.gnome.desktop.$file.gschema.xml.in" \
        --replace "@datadir@" "${gnome3.gnome-backgrounds}/share/"
    done
  '';

  buildInputs = [ glib gobjectIntrospection ];

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    maintainers = gnome3.maintainers;
  };
}
