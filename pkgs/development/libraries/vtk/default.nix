{stdenv, fetchurl, cmake, mesa, libX11, xproto, libXt }:

stdenv.mkDerivation {
  name = "vtk-5.2.1";
  src = fetchurl {
    url = http://www.vtk.org/files/release/5.2/vtk-5.2.1.tar.gz;
    sha256 = "c81521b3767a044745336212cbde500d6e97a1f8ba647bc590857e36f57003bb";
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
