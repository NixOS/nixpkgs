{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper
, pkg-config, libX11, libuuid, xz, vtk, Cocoa }:

stdenv.mkDerivation rec {
  pname = "itk";
  version = "5.2.1";

  itkGenericLabelInterpolatorSrc = fetchFromGitHub {
    owner = "InsightSoftwareConsortium";
    repo = "ITKGenericLabelInterpolator";
    rev = "2f3768110ffe160c00c533a1450a49a16f4452d9";
    hash = "sha256-Cm3jg14MMnbr/sP+gqR2Rh25xJjoRvpmY/jP/DKH978=";
  };

  itkAdaptiveDenoisingSrc = fetchFromGitHub {
    owner = "ntustison";
    repo = "ITKAdaptiveDenoising";
    rev = "24825c8d246e941334f47968553f0ae388851f0c";
    hash = "sha256-deJbza36c0Ohf9oKpO2T4po37pkyI+2wCSeGL4r17Go=";
  };

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
    ln -sr ${itkGenericLabelInterpolatorSrc} Modules/External/ITKGenericLabelInterpolator
    ln -sr ${itkAdaptiveDenoisingSrc} Modules/External/ITKAdaptiveDenoising
  '';

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DITK_FORBID_DOWNLOADS=ON"
    "-DModule_ITKMINC=ON"
    "-DModule_ITKIOMINC=ON"
    "-DModule_ITKIOTransformMINC=ON"
    "-DModule_ITKVtkGlue=ON"
    "-DModule_ITKReview=ON"
    "-DModule_MGHIO=ON"
    "-DModule_AdaptiveDenoising=ON"
    "-DModule_GenericLabelInterpolator=ON"
  ];

  nativeBuildInputs = [ cmake xz makeWrapper ];
  buildInputs = [ libX11 libuuid vtk ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

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
