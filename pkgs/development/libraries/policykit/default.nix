{ stdenv, fetchurl, pkgconfig, glib, dbus, dbus_glib, expat, pam
, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "policykit-0.9";
  
  src = fetchurl {
    url = http://hal.freedesktop.org/releases/PolicyKit-0.9.tar.gz;
    sha256 = "1dw05s4xqj67i3c13knzl04l8jap0kywzpav6fidpmqrximpq37l";
  };
  
  buildInputs = [ pkgconfig glib dbus.libs dbus_glib expat pam intltool gettext ];

  configureFlags = "--localstatedir=/var";

  installFlags = "localstatedir=$(TMPDIR)/var"; # keep `make install' happy
  
  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/PolicyKit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
  };
}
