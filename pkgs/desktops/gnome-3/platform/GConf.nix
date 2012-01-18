{ stdenv, fetchurl_gnome, glib, dbus_glib, pkgconfig, libxml2, gtk, intltool }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "GConf";
    major = "3"; minor = "2"; patchlevel = "0"; extension = "xz";
    sha256 = "02vdm6slc2mdw0yfl6lh7qawqcb2k7sk6br21fdj1vfp55ap8wgk";
  };

  propagatedBuildInputs = [ glib dbus_glib libxml2 gtk ];
  buildNativeInputs = [ pkgconfig intltool ];

  configureFlags = "--disable-orbit";

  meta = {
    homepage = http://projects.gnome.org/gconf/;
    description = "A system for storing application preferences";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (gtk.meta) platforms;
  };
}
