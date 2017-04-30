{ stdenv, fetchurl, python, pkgconfig, popt, intltool, dbus_glib
, libX11, xextproto, libSM, libICE, libXtst, libXi, gobjectIntrospection }:

stdenv.mkDerivation rec {
  versionMajor = "2.22";
  versionMinor = "1";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "6f8f39f091bfe2c57870cb8bfbb02edac4fc85cda69665e6967937daf7201c42";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    python pkgconfig popt  intltool dbus_glib
    libX11 xextproto libSM libICE libXtst libXi
    gobjectIntrospection
  ];

  # ToDo: on non-NixOS we create a symlink from there?
  configureFlags = "--with-dbus-daemondir=/run/current-system/sw/bin/";

  NIX_LDFLAGS = with stdenv; lib.optionalString isDarwin "-lintl";

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}

