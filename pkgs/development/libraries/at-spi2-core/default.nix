{ stdenv, fetchurl, pkgconfig, gettext, meson, ninja
, python, popt, dbus-glib
, libX11, xextproto, libSM, libICE, libXtst, libXi, gobjectIntrospection }:

stdenv.mkDerivation rec {
  versionMajor = "2.28";
  versionMinor = "0";
  moduleName   = "at-spi2-core";
  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "11qwdxxx4jm0zj04xydlwah41axiz276dckkiql3rr0wn5x4i8j2";
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
