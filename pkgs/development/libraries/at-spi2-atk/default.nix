{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xorg, libXi
, intltool, dbus_glib, at_spi2_core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.16";
  versionMinor = "0";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1y9gfz1iz3wpja7s000f0bmyyvc6im5fcdl6bxwbz0v3qdgc9vvq";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xorg.libXtst libXi
                  intltool dbus_glib at_spi2_core libSM ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
