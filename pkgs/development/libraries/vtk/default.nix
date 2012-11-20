{ stdenv, fetchurl, cmake, mesa, libX11, xproto, libXt
, useQt4 ? false, qt4 }:

with stdenv.lib;

let
  os = stdenv.lib.optionalString;
  majorVersion = "5.10";
  minorVersion = "0";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${os useQt4 "qvtk-"}${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/vtk-${version}.tar.gz";
    md5 = "a0363f78910f466ba8f1bd5ab5437cb9";
  };
  buildInputs = [ cmake mesa libX11 xproto libXt ]
    ++ optional useQt4 qt4;

  cmakeFlags = optional useQt4
    [ "-DVTK_USE_QT:BOOL=ON" ];

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = http://www.vtk.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ viric bbenoist ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
