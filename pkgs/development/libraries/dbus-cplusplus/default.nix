{ stdenv, fetchurl, dbus, glib, pkgconfig, expat }:

stdenv.mkDerivation rec {
  name = "dbus-cplusplus-${version}";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/dbus-cplusplus/dbus-c%2B%2B/0.9.0/libdbus-c%2B%2B-0.9.0.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "0qafmy2i6dzx4n1dqp6pygyy6gjljnb7hwjcj2z11c1wgclsq4dw";
  };

  patches = [
    (fetchurl {
      name = "gcc-4.7.patch";
      url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/dev-libs/"
          + "dbus-c%2B%2B/files/dbus-c%2B%2B-0.9.0-gcc-4.7.patch";
      sha256 = "0rwcz9pvc13b3yfr0lkifnfz0vb5q6dg240bzgf37ni4s8rpc72g";
    })
    (fetchurl {
      name = "writechar.patch"; # since gcc7
      url = "https://src.fedoraproject.org/cgit/rpms/dbus-c++.git/plain/"
          + "dbus-c++-writechar.patch?id=7f371172f5c";
      sha256 = "1kkg4gbpm4hp87l25zw2a3r9c58g7vvgzcqgiman734i66zsbb9l";
    })
    (fetchurl {
      name = "threading.patch"; # since gcc7
      url = "https://src.fedoraproject.org/cgit/rpms/dbus-c++.git/plain/"
          + "dbus-c++-threading.patch?id=7f371172f5c";
      sha256 = "1h362anx3wyxm5lq0v8girmip1jmkdbijrmbrq7k5pp47zkhwwrq";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus glib expat ];

  configureFlags = [ "--disable-ecore" ];

  meta = with stdenv.lib; {
    homepage = http://dbus-cplusplus.sourceforge.net;
    description = "C++ API for D-BUS";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
