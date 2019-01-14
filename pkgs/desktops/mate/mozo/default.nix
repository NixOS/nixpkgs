{ stdenv, fetchurl, pkgconfig, intltool, mate, pythonPackages }:

stdenv.mkDerivation rec {
  name = "mozo-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1q4hqhigimxav2a8xxyd53lq8q80szsphcv37y2jhm6g6wvdmvhd";
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
