{
  version,
  rev,
  sourceSha256,
}:

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  castxml,
  swig,
  expat,
  eigen,
  fftw,
  gdcm,
  hdf5-cpp,
  libjpeg,
  libminc,
  libtiff,
  libpng,
  libX11,
  libuuid,
  patchelf,
  python ? null,
  numpy ? null,
  xz,
  vtk,
  which,
  zlib,
  Cocoa,
  enablePython ? false,
}:

let
  # Python wrapper contains its own VTK support incompatible with MODULE_ITKVtkGlue
  withVtk = !enablePython;

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

  rtkSrc = fetchFromGitHub {
    owner = "RTKConsortium";
    repo = "RTK";
    rev = "583288b1898dedcfb5e4d602e31020b452971383";
    hash = "sha256-1ItsLCRwRzGDSRe4xUDg09Hksu1nKichbWuM0YSVkbM=";
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

  patches = lib.optionals (lib.versionOlder version "5.4") [
    (fetchpatch {
      name = "fix-gcc13-build";
      url = "https://github.com/InsightSoftwareConsortium/ITK/commit/9a719a0d2f5f489eeb9351b0ef913c3693147a4f.patch";
      hash = "sha256-dDyqYOzo91afR8W7k2N64X6l7t6Ws1C9iuRkWHUe0fg=";
    })
  ];

  postPatch = ''
    substituteInPlace CMake/ITKSetStandardCompilerFlags.cmake  \
      --replace "-march=corei7" ""  \
      --replace "-mtune=native" ""
    ln -sr ${itkGenericLabelInterpolatorSrc} Modules/External/ITKGenericLabelInterpolator
    ln -sr ${itkAdaptiveDenoisingSrc} Modules/External/ITKAdaptiveDenoising
    ln -sr ${itkSimpleITKFiltersSrc} Modules/External/ITKSimpleITKFilters
    ln -sr ${rtkSrc} Modules/Remote/RTK
  '';

  cmakeFlags =
    [
      "-DBUILD_EXAMPLES=OFF"
      "-DBUILD_SHARED_LIBS=ON"
      "-DITK_FORBID_DOWNLOADS=ON"
      "-DITK_USE_SYSTEM_LIBRARIES=ON" # finds common libraries e.g. hdf5, libpng, libtiff, zlib, but not GDCM, NIFTI, MINC, etc.
      "-DITK_USE_SYSTEM_EIGEN=ON"
      "-DITK_USE_SYSTEM_EIGEN=OFF"
      "-DITK_USE_SYSTEM_GOOGLETEST=OFF" # ANTs build failure due to https://github.com/ANTsX/ANTs/issues/1489
      "-DITK_USE_SYSTEM_GDCM=ON"
      "-DITK_USE_SYSTEM_MINC=ON"
      "-DLIBMINC_DIR=${libminc}/lib/cmake"
      "-DModule_ITKMINC=ON"
      "-DModule_ITKIOMINC=ON"
      "-DModule_ITKIOTransformMINC=ON"
      "-DModule_SimpleITKFilters=ON"
      "-DModule_ITKReview=ON"
      "-DModule_MGHIO=ON"
      "-DModule_AdaptiveDenoising=ON"
      "-DModule_GenericLabelInterpolator=ON"
      "-DModule_RTK=ON"
    ]
    ++ lib.optionals enablePython [
      "-DITK_WRAP_PYTHON=ON"
      "-DITK_USE_SYSTEM_CASTXML=ON"
      "-DITK_USE_SYSTEM_SWIG=ON"
      "-DPY_SITE_PACKAGES_PATH=${placeholder "out"}/${python.sitePackages}"
    ]
    ++ lib.optionals withVtk [ "-DModule_ITKVtkGlue=ON" ];

  nativeBuildInputs =
    [
      cmake
      xz
    ]
    ++ lib.optionals enablePython [
      castxml
      swig
      which
    ];

  buildInputs =
    [
      eigen
      libX11
      libuuid
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa ]
    ++ lib.optionals enablePython [ python ]
    ++ lib.optionals withVtk [ vtk ];
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
  ] ++ lib.optionals withVtk vtk.propagatedBuildInputs ++ lib.optionals enablePython [ numpy ];

  postInstall = lib.optionalString enablePython ''
    substitute \
      ${./itk.egg-info} \
      $out/${python.sitePackages}/itk-${version}.egg-info \
      --subst-var-by ITK_VER "${version}"
  '';

  # remove forbidden reference to /build which occur when building the Python wrapping
  # (also remove a copy of itkTestDriver with incorrect permissions/RPATH):
  preFixup = lib.optionals enablePython ''
    rm $out/${python.sitePackages}/itk/itkTestDriver
    find $out/${python.sitePackages}/itk -type f -name '*.so*' -exec \
      patchelf {} --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" \;
  '';

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = "https://www.itk.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
    # aarch64-linux Python wrapping fails with "error: unknown type name '_Float128'" and similar;
    # compilation runs slowly and times out on Darwin
    platforms = with lib.platforms; if enablePython then [ "x86_64-linux" ] else unix;
  };
}
