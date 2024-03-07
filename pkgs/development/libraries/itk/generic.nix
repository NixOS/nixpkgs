{ version, rev, sourceSha256 }:

{ lib, stdenv, fetchFromGitHub, cmake
, expat, fftw, gdcm, hdf5-cpp, libjpeg, libminc, libtiff, libpng
, libX11, libuuid, xz, vtk, zlib, Cocoa }:

let
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

  itkSimpleITKFiltersSrc = fetchFromGitHub {
    owner = "InsightSoftwareConsortium";
    repo = "ITKSimpleITKFilters";
    rev = "bb896868fc6480835495d0da4356d5db009592a6";
    hash = "sha256-MfaIA0xxA/pzUBSwnAevr17iR23Bo5iQO2cSyknS3o4=";
  };
in

stdenv.mkDerivation {
  pname = "itk";
  inherit version;

  src = fetchFromGitHub {
    owner = "InsightSoftwareConsortium";
    repo = "ITK";
    inherit rev;
    sha256 = sourceSha256;
  };

  postPatch = ''
    substituteInPlace CMake/ITKSetStandardCompilerFlags.cmake  \
      --replace "-march=corei7" ""  \
      --replace "-mtune=native" ""
    ln -sr ${itkGenericLabelInterpolatorSrc} Modules/External/ITKGenericLabelInterpolator
    ln -sr ${itkAdaptiveDenoisingSrc} Modules/External/ITKAdaptiveDenoising
    ln -sr ${itkSimpleITKFiltersSrc} Modules/External/ITKSimpleITKFilters
  '';

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DITK_FORBID_DOWNLOADS=ON"
    "-DITK_USE_SYSTEM_LIBRARIES=ON"  # finds common libraries e.g. hdf5, libpng, libtiff, zlib, but not GDCM, NIFTI, MINC, etc.
    # note ITK_USE_SYSTEM_EIGEN, part of ITK_USE_SYSTEM_LIBRARIES,
    # causes "...-itk-5.2.1/include/ITK-5.2/itkSymmetricEigenAnalysis.h:23:31: fatal error: Eigen/Eigenvalues: No such file or directory"
    # when compiling c3d, but maybe an ITK 5.2/eigen version issue:
    "-DITK_USE_SYSTEM_EIGEN=OFF"
    "-DITK_USE_SYSTEM_GOOGLETEST=OFF"  # ANTs build failure due to https://github.com/ANTsX/ANTs/issues/1489
    "-DITK_USE_SYSTEM_GDCM=ON"
    "-DITK_USE_SYSTEM_MINC=ON"
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DModule_ITKMINC=ON"
    "-DModule_ITKIOMINC=ON"
    "-DModule_ITKIOTransformMINC=ON"
    "-DModule_SimpleITKFilters=ON"
    "-DModule_ITKVtkGlue=ON"
    "-DModule_ITKReview=ON"
    "-DModule_MGHIO=ON"
    "-DModule_AdaptiveDenoising=ON"
    "-DModule_GenericLabelInterpolator=ON"
  ];

  nativeBuildInputs = [ cmake xz ];
  buildInputs = [
    libX11
    libuuid
    vtk
  ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];
  # Due to ITKVtkGlue=ON and the additional dependencies needed to configure VTK 9
  # (specifically libGL and libX11 on Linux),
  # it's now seemingly necessary for packages that configure ITK to
  # also include configuration deps of VTK, even if VTK is not required or available.
  # These deps were propagated from VTK 9 in https://github.com/NixOS/nixpkgs/pull/206935,
  # so we simply propagate them again from ITK.
  # This admittedly is a hack and seems like an issue with VTK 9's CMake configuration.
  propagatedBuildInputs = [
    # The dependencies we've un-vendored from ITK, such as GDCM, must be propagated,
    # otherwise other software built against ITK fails to configure since ITK headers
    # refer to these previously vendored libraries:
    expat
    fftw
    gdcm
    hdf5-cpp
    libjpeg
    libminc
    libpng
    libtiff
    zlib
  ] ++ vtk.propagatedBuildInputs;

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = "https://www.itk.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [viric];
  };
}
