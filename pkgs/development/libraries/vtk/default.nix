{stdenv, fetchurl, cmake, mesa, libX11, xproto, libXt }:

stdenv.mkDerivation rec {
  name = "vtk-5.4.2";
  src = fetchurl {
    url = "http://www.vtk.org/files/release/5.4/${name}.tar.gz";
    sha256 = "0gd7xlxiqww6xxcs2kicz0g6k147y3200np4jnsf10vlxs10az03";
  };
  buildInputs = [ cmake mesa libX11 xproto libXt ];

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = http://www.vtk.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
