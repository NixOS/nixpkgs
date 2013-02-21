{ stdenv, fetchurl, pkgconfig, intltool, glib }:

stdenv.mkDerivation rec {

  versionMajor = "3.6";
  versionMinor = "1";
  moduleName   = "gsettings-desktop-schemas";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1rk71q2rky9nzy0zb5jsvxa62vhg7dk65kdgdifq8s761797ga6r";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [ pkgconfig intltool ];
}
