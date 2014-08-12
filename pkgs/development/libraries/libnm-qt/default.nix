{ stdenv, fetchurl, cmake, pkgconfig, qt4, networkmanager, libmm-qt }:

let
  pname = "libnm-qt";
  version = "0.9.8.2";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  buildInputs = [
    cmake
    pkgconfig
    qt4
    networkmanager
  ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  propagatedBuildInputs = [ libmm-qt ];

  src = fetchurl {
    url = "mirror://kde/unstable/networkmanager-qt/${version}/src/${name}.tar.xz";
    sha256 = "118fa4732536677f889b2776ec45bd0c726f26abcb8e8b6f8dfcaee265475f33";
  };

  meta = with stdenv.lib; {
    homepage = "https://projects.kde.org/projects/extragear/libs/libnm-qt";
    description = "Qt wrapper for NetworkManager DBus API";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.jgeerds ];
  };
}
