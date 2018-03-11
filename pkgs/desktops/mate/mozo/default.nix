{ stdenv, fetchurl, pkgconfig, intltool, mate, pythonPackages }:

stdenv.mkDerivation rec {
  name = "mozo-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1108avdappfjadd46ld7clhh5m9f4b5khl5y33l377m8ky9dy87g";
  };
  
  pythonPath = [ mate.mate-menus pythonPackages.pygobject3 ];

  nativeBuildInputs = [ pkgconfig intltool pythonPackages.wrapPython ];

  buildInputs = [ pythonPackages.python ] ++ pythonPath;

  preFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "MATE Desktop menu editor";
    homepage = https://github.com/mate-desktop/mozo;
    license = with licenses; [ lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
