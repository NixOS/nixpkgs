{ lib, stdenv, fetchurl, fetchpatch, dbus, glib, pkg-config, expat }:

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
    (fetchpatch {
      name = "writechar.patch"; # since gcc7
      url = "https://src.fedoraproject.org/rpms/dbus-c++/raw/9f515ace0594c8b2b9f0d41ffe71bc5b78d30eee/f/dbus-c++-writechar.patch";
      sha256 = "1kkg4gbpm4hp87l25zw2a3r9c58g7vvgzcqgiman734i66zsbb9l";
    })
    (fetchpatch {
      name = "threading.patch"; # since gcc7
      url = "https://src.fedoraproject.org/rpms/dbus-c++/raw/9f515ace0594c8b2b9f0d41ffe71bc5b78d30eee/f/dbus-c++-threading.patch";
      sha256 = "1h362anx3wyxm5lq0v8girmip1jmkdbijrmbrq7k5pp47zkhwwrq";
    })
    (fetchpatch {
      name = "template-operators.patch"; # since gcc12
      url = "https://src.fedoraproject.org/rpms/dbus-c++/raw/9f515ace0594c8b2b9f0d41ffe71bc5b78d30eee/f/dbus-c++-template-operators.patch";
      hash = "sha256-B8S7z/YH2YEQgaRsBJBBVTx8vHQhHW7z171TZmogpL8=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus glib expat ];

  configureFlags = [ "--disable-ecore" "--disable-tests" ];

  meta = with lib; {
    homepage = "https://dbus-cplusplus.sourceforge.net";
    description = "C++ API for D-BUS";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
    # Broken for Musl at 2023-12-28:
    # https://github.com/NixOS/nixpkgs/issues/277198
    broken = stdenv.hostPlatform.isMusl;
  };
}
