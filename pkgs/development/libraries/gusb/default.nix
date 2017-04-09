{stdenv, fetchurl
, automake, autoconf, libtool, which, gtkdoc, gettext, pkgconfig, gobjectIntrospection, libxslt
, glib, systemd, libusb1, vala_0_23
}:
stdenv.mkDerivation rec {
  name = "gusb-${version}";
  version = "0.2.9";
  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
    sha256 = "056yxlppgycsfw1l8c9j6givk1n15jylhvx89wqhsxdi1b6vs83k";
  };

  preConfigure = "./autogen.sh";

  buildInputs = [
    pkgconfig autoconf automake libtool which gtkdoc gettext gobjectIntrospection libxslt
    systemd vala_0_23 glib
  ];

  propagatedBuildInputs = [ libusb1 ];

  meta = {
    description = "GLib libusb wrapper";
    homepage = http://people.freedesktop.org/~hughsient/releases/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
