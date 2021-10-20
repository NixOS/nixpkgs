{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper
, pkg-config, libX11, libuuid, xz, vtk_7, Cocoa }:

stdenv.mkDerivation rec {
  pname = "itk";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "InsightSoftwareConsortium";
    repo = "ITK";
    rev = "v${version}";
    sha256 = "sha256-KaVe9FMGm4ZVMpwAT12fA67T0qZS3ZueiI8z85+xSwE=";
  };

  postPatch = ''
    substituteInPlace CMake/ITKSetStandardCompilerFlags.cmake  \
      --replace "-march=corei7" ""  \
      --replace "-mtune=native" ""
  '';

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DModule_ITKMINC=ON"
    "-DModule_ITKIOMINC=ON"
    "-DModule_ITKIOTransformMINC=ON"
    "-DModule_ITKVtkGlue=ON"
    "-DModule_ITKReview=ON"
  ];

  nativeBuildInputs = [ cmake xz makeWrapper ];
  buildInputs = [ libX11 libuuid vtk_7 ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  postInstall = ''
    wrapProgram "$out/bin/h5c++" --prefix PATH ":" "${pkg-config}/bin"
  '';

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = "https://www.itk.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [viric];
  };
}
