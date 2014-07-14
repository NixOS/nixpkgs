{ stdenv, fetchurl, cmake, pkgconfig, qt4, doxygen, modemmanager }:

let
  pname = "libmm-qt";
  version = "1.0.1";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  buildInputs = [
    cmake
    pkgconfig
    qt4
    doxygen
  ];

  propagatedBuildInputs = [ modemmanager ];

  src = fetchurl {
    url = "mirror://kde/unstable/modemmanager-qt/${version}/src/${name}-1.tar.xz";
    sha256 = "0ad57815a904ddb2660a7327c0bda5da47a2a60ce57b2b12f4aaff99b174f74a";
  };

  meta = with stdenv.lib; {
    homepage = "https://projects.kde.org/projects/extragear/libs/libmm-qt";
    description = "Qt wrapper for ModemManager DBus API";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.jgeerds ];
  };
}
