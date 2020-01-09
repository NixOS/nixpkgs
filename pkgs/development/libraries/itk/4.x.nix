{ stdenv, fetchurl, cmake, libX11, libuuid, xz, vtk }:

stdenv.mkDerivation rec {
  name = "itk-4.13.2";

  src = fetchurl {
    url = mirror://sourceforge/itk/InsightToolkit-4.13.2.tar.xz;
    sha256 = "19cgfpd63gqrvc3m27m394gy2d7w79g5y6lvznb5qqr49lihbgns";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DModule_ITKMINC=ON"
    "-DModule_ITKIOMINC=ON"
    "-DModule_ITKIOTransformMINC=ON"
    "-DModule_ITKVtkGlue=ON"
    "-DModule_ITKReview=ON"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake xz ];
  buildInputs = [ libX11 libuuid vtk ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = http://www.itk.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
