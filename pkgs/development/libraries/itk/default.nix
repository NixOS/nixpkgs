{ stdenv, fetchurl, cmake, libX11, libuuid, xz, vtk }:

stdenv.mkDerivation rec {
  name = "itk-5.0.0";

  src = fetchurl {
    url = mirror://sourceforge/itk/InsightToolkit-5.0.0.tar.xz;
    sha256 = "0bs63mk4q8jmx38f031jy5w5n9yy5ng9x8ijwinvjyvas8cichqi";
  };

  cmakeFlags = [
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
