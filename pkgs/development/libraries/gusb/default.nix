{stdenv, fetchurl, fetchgit
, automake, autoconf, libtool, which, gtkdoc, gettext, pkgconfig, gobjectIntrospection, libxslt
, glib, systemd, libusb1
}:
stdenv.mkDerivation {
  name = "gusb-git";
  enableParallelBuilding = true;

  src = fetchgit {
    url = git://gitorious.org/gusb/gusb.git;
    rev = "53226a15a627b20fde38303c2141a17985d741ae";
    sha256 = "01daf09f663e27bdd92532e3e2a3e87de895e9cc1f150d4e0fc75b0dc489fccf";
  };

  preConfigure = "./autogen.sh";

  buildInputs = [
    pkgconfig autoconf automake libtool which gtkdoc gettext gobjectIntrospection libxslt
    systemd libusb1
    glib
  ];

  meta = {
    description = "GLib libusb wrapper";
    homepage = http://gitorious.org/gusb;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
