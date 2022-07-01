{ lib, stdenv, fetchurl, dbus, glib, pkg-config, expat }:

stdenv.mkDerivation rec {
  pname = "dbus-cplusplus";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/dbus-cplusplus/dbus-c%2B%2B/0.9.0/libdbus-c%2B%2B-0.9.0.tar.gz";
    name = "${pname}-${version}.tar.gz";
    sha256 = "0qafmy2i6dzx4n1dqp6pygyy6gjljnb7hwjcj2z11c1wgclsq4dw";
  };

  patches = [
    (fetchurl {
      name = "gcc-4.7.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/"
          + "dbus-c++/files/dbus-c++-0.9.0-gcc-4.7.patch";
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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus glib expat ];

  configureFlags = [ "--disable-ecore" "--disable-tests" ];

  meta = with lib; {
    homepage = "http://dbus-cplusplus.sourceforge.net";
    description = "C++ API for D-BUS";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
