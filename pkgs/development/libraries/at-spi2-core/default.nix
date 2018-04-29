{ stdenv, fetchurl, python, pkgconfig, popt, gettext, dbus-glib
, libX11, xextproto, libSM, libICE, libXtst, libXi, gobjectIntrospection }:

stdenv.mkDerivation rec {
  versionMajor = "2.26";
  versionMinor = "2";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "0596ghkamkxgv08r4a1pdhm06qd5zzgcfqsv64038w9xbvghq3n8";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig gettext gobjectIntrospection ];
  buildInputs = [
    python popt dbus-glib
    libX11 xextproto libSM libICE libXtst libXi
  ];

  # ToDo: on non-NixOS we create a symlink from there?
  configureFlags = "--with-dbus-daemondir=/run/current-system/sw/bin/";

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
