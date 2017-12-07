{ stdenv, fetchurl, python, pkgconfig, popt, intltool, dbus_glib
, libX11, xextproto, libSM, libICE, libXtst, libXi, gobjectIntrospection }:

stdenv.mkDerivation rec {
  versionMajor = "2.26";
  versionMinor = "0";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "511568a65fda11fdd5ba5d4adfd48d5d76810d0e6ba4f7460f1b2ec0dbbbc337";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python popt  intltool dbus_glib
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

