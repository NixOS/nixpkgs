{stdenv, fetchurl
, automake, autoconf, libtool, which, gtkdoc, gettext, pkgconfig, gobjectIntrospection, libxslt
, glib, systemd, libusb1, vala_0_23
}:
stdenv.mkDerivation rec {
  name = "gusb-${version}";
  version = "0.2.4";
  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
    sha256 = "10w0sdq7505iwd8y305aylmx4zafbnphs81cgdsqw2z38pxncya3";
  };

  preConfigure = "./autogen.sh";

  buildInputs = [
    pkgconfig autoconf automake libtool which gtkdoc gettext gobjectIntrospection libxslt
    systemd libusb1 vala_0_23
    glib
  ];

  meta = {
    description = "GLib libusb wrapper";
    homepage = http://people.freedesktop.org/~hughsient/releases/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
