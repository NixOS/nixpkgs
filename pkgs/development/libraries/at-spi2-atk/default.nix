{ stdenv, fetchurl, python, pkgconfig, popt, atk, libX11, libICE, xorg, libXi
, intltool, dbus_glib, at_spi2_core, libSM }:

stdenv.mkDerivation rec {
  versionMajor = "2.18";
  versionMinor = "0";
  moduleName   = "at-spi2-atk";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "0xgkrnx04vaklbkzc7bzym9s0qhj8aiz4knqlxgx3vxnacsb6vaa";
  };

  buildInputs = [ python pkgconfig popt atk libX11 libICE xorg.libXtst libXi
                  intltool dbus_glib at_spi2_core libSM ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
