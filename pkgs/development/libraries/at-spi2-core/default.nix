{ stdenv, fetchurl, pkgconfig, gettext, meson, ninja
, python, popt, dbus-glib
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

  nativeBuildInputs = [ meson ninja pkgconfig gettext gobjectIntrospection ];
  buildInputs = [
    python popt dbus-glib
    libX11 xextproto libSM libICE libXtst libXi
  ];

  doCheck = false; # needs dbus daemon

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
