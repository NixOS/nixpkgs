{ stdenv, fetchurl, pkgconfig, dbus, dbus_glib, gtk, glib }:
 
stdenv.mkDerivation rec {
  name = "libnotify-0.4.5";

  src = fetchurl {
    url = "http://www.galago-project.org/files/releases/source/libnotify/${name}.tar.gz";
    sha256 = "1ndh7wpm9qh12vm5avjrq2xv1j681j9qq6j2fyj6a2shl67dp687";
  };

  buildInputs = [ pkgconfig dbus.libs dbus_glib gtk glib ];

  meta = {
    homepage = http://galago-project.org/;
    description = "A library that sends desktop notifications to a notification daemon";
  };
}
