{ stdenv, fetchurl, meson, ninja, pkgconfig
, at-spi2-core, atk, dbus, glib, libxml2 }:

stdenv.mkDerivation rec {
  name = "${moduleName}-${versionMajor}.${versionMinor}";
  moduleName   = "at-spi2-atk";
  versionMajor = "2.26";
  versionMinor = "2";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "0vkan52ab9vrkknnv8y4f1cspk8x7xd10qx92xk9ys71p851z2b1";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ at-spi2-core atk dbus glib libxml2 ];

  meta = with stdenv.lib; {
    description = "D-Bus bridge for Assistive Technology Service Provider Interface (AT-SPI) and Accessibility Toolkit (ATK)";
    homepage = "https://gitlab.gnome.org/GNOME/at-spi2-atk";
    platforms = platforms.unix;

  };
}
