{ lib, stdenv, fetchFromGitHub, cmake, libX11, libuuid, xz, vtk_7, Cocoa }:

stdenv.mkDerivation rec {
  pname = "itk";
  version = "4.13.3";

  src = fetchFromGitHub {
    owner = "InsightSoftwareConsortium";
    repo = "ITK";
    rev = "v${version}";
    sha256 = "067vkh39jxcvyvn69qjh4vi3wa7vdvm9m6qsg3jmnmm7gzw0kjlm";
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

  nativeBuildInputs = [ cmake xz ];
  buildInputs = [ libX11 libuuid vtk_7 ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = "https://www.itk.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
