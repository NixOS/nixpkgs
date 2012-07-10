{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xlibs, libXi
, intltool, dbus_glib }:

stdenv.mkDerivation {
  name = "at-spi2-atk-2.5.3";

  src = fetchurl {
    url = mirror://gnome/sources/at-spi2-atk/2.5/at-spi2-atk-2.5.3.tar.xz;
    sha256 = "16y6q0v3va7r77ns1r6w4mg3rvyxmnyzx1b3n0wqjzmqkd8avgmx";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xlibs.libXtst libXi
                  intltool dbus_glib ];
}
