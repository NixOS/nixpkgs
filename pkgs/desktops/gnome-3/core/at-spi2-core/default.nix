{ stdenv, fetchurl, python, pkgconfig, popt, intltool, dbus_glib
, libX11, xextproto, libSM, libICE, libXtst, libXi }:

stdenv.mkDerivation (rec {
  versionMajor = "2.10";
  versionMinor = "2";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1qfxlbmbaihgmqgkxnywnji9wkbvn8pvbv20x5glv3jc9zw5innk";
  };

  buildInputs = [
    python pkgconfig popt  intltool dbus_glib
    libX11 xextproto libSM libICE libXtst libXi
  ];

  # ToDo: on non-NixOS we create a symlink from there?
  configureFlags = "--with-dbus-daemondir=/run/current-system/sw/bin/";
}
  // stdenv.lib.optionalAttrs stdenv.isDarwin {
    NIX_LDFLAGS = "-lintl";
  }
)

