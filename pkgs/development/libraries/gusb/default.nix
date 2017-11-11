{stdenv, fetchurl
, automake, autoconf, libtool, which, gtkdoc, gettext, pkgconfig, gobjectIntrospection, libxslt
, glib, systemd, libusb1, vala_0_38
}:
stdenv.mkDerivation rec {
  name = "gusb-${version}";
  version = "0.2.11";
  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
    sha256 = "1pppz17lw3khyz8by1dddxdqrv6qn4a23fpxs38c67db7x4l7ccw";
  };

  preConfigure = "./autogen.sh";

  nativeBuildInputs = [ pkgconfig autoconf automake libtool which gtkdoc gettext
                        gobjectIntrospection libxslt vala_0_38 ];
  buildInputs = [ systemd  glib ];

  propagatedBuildInputs = [ libusb1 ];

  meta = {
    description = "GLib libusb wrapper";
    homepage = https://people.freedesktop.org/~hughsient/releases/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
