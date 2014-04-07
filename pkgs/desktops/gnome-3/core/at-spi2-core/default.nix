{ stdenv, fetchurl, python, pkgconfig, popt, intltool, dbus_glib
, libX11, xextproto, libSM, libICE, libXtst, libXi, gobjectIntrospection }:

stdenv.mkDerivation (rec {
  versionMajor = "2.12";
  versionMinor = "0";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "12gvsgdaxnxskndlhlmdkc50cfqgmzfc4n8la9944fz5k3fhwmfv";
  };

  buildInputs = [
    python pkgconfig popt  intltool dbus_glib
    libX11 xextproto libSM libICE libXtst libXi
    gobjectIntrospection
  ];

  # ToDo: on non-NixOS we create a symlink from there?
  configureFlags = "--with-dbus-daemondir=/run/current-system/sw/bin/";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
  // stdenv.lib.optionalAttrs stdenv.isDarwin {
    NIX_LDFLAGS = "-lintl";
  }
)

