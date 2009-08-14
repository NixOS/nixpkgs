{ stdenv, fetchurl, pkgconfig, dbus_glib, zlib, pam, glib, libX11, policy_kit }:

stdenv.mkDerivation rec {
  name = "console-kit-0.3.1";
  
  src = fetchurl {
    url = http://www.freedesktop.org/software/ConsoleKit/dist/ConsoleKit-0.3.1.tar.bz2;
    sha256 = "0b834ly6l8l76awr2pn2xz3ic6ilhfif4h3nsi96ffa91n09ydk0";
  };
  
  buildInputs = [ pkgconfig dbus_glib zlib pam glib libX11 policy_kit ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/ConsoleKit;
    description = "A framework for defining and tracking users, login sessions, and seats";
  };
}
