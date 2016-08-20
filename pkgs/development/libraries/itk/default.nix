{ stdenv, fetchurl, cmake, libX11, libuuid, xz, vtk }:

stdenv.mkDerivation rec {
  name = "itk-4.13.0";

  src = fetchurl {
    url = mirror://sourceforge/itk/InsightToolkit-4.13.0.tar.xz;
    sha256 = "09d1gmqx3wbdfgwf7r91r12m2vknviv0i8wxwh2q9w1vrpizrczy";
  };

  cmakeFlags = {
    BUILD_EXAMPLES = false;
    BUILD_SHARED_LIBS = true;
    BUILD_TESTING = false;
    Module_ITKIOMINC = true;
    Module_ITKIOTransformMINC = true;
    Module_ITKMINC = true;
    Module_ITKReview = true;
    Module_ITKVtkGlue = true;
  };

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
