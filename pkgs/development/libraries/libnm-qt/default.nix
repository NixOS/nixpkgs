{ stdenv, fetchurl, cmake, pkgconfig, qt4, networkmanager, libmm-qt }:

let
  pname = "libnm-qt";
  version = "0.9.8.1";
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

  propagatedBuildInputs = [ libmm-qt ];

  src = fetchurl {
    url = "mirror://kde/unstable/networkmanager-qt/${version}/src/${name}.tar.xz";
    sha256 = "cde8bed2beb57015cb5f6772c1fe0843aab299b9529578c5406ba7fe614af23d";
  };

  meta = with stdenv.lib; {
    homepage = "https://projects.kde.org/projects/extragear/libs/libnm-qt";
    description = "Qt wrapper for NetworkManager DBus API";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainer = [ maintainers.jgeerds ];
  };
}
