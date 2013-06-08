{ stdenv, fetchurl, glib, dbus_glib, pkgconfig, libxml2, gtk3, intltool, polkit }:

stdenv.mkDerivation {
  name = "GConf-3.2.3";

  src = fetchurl {
    url = mirror://gnome/sources/GConf/3.2/GConf-3.2.3.tar.xz;
    sha256 = "0jd1z9gb1b7mv4g07qm554va6idasf3swgrfqflypdh9s38mvdcy";
  };

  propagatedBuildInputs = [ glib dbus_glib ];
  buildInputs = [ polkit gtk3 libxml2 ];
  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = "--disable-orbit";

  meta = {
    homepage = http://projects.gnome.org/gconf/;
    description = "A system for storing application preferences";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (gtk3.meta) platforms;
  };
}
