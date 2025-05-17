{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  cmake,
  python3Packages,

  # buildInputs
  mpi,
  fmt,
  eigen,
  exprtk,
  utf8cpp,
  verdict,
  nlohmann_json,
  double-conversion,

  # common data libraries
  lz4,
  xz,
  zlib,
  pugixml,
  expat,
  jsoncpp,
  libxml2,

  # io modules
  ffmpeg,
  libjpeg,
  libpng,
  libtiff,
  proj,
  sqlite,
  libogg,
  libharu,
  libtheora,
  hdf5,
  netcdf,
  adios2,
  opencascade-occt,

  # threading
  tbb_2022_0,

  # rendering
  freetype,
  libX11,
  libXcursor,
  gl2ps,
  libGL,
  qt5,
  qt6,

  # check
  cli11,
  ctestCheckHook,
  nixGLMesaHook,
  mpiCheckPhaseHook,
  headlessDisplayCheckHook,

  # custom options
  mpiSupport ? true,
  qtVersion ? 6,
  enablePython ? false,
}:

let
  qtPackages =
    if (qtVersion == 6) then
      qt6
    else if (qtVersion == 5) then
      qt5
    else
      throw "qtVersion must be either 5 or 6";
  vtkPackages = qtPackages.overrideScope (
    final: prev: {
      inherit
        mpi
        mpiSupport
        enablePython
        python3Packages
        ;
      python3 = python3Packages.python;
      pythonSupport = enablePython;

      hdf5 = hdf5.override {
        inherit mpi mpiSupport;
        cppSupport = !mpiSupport;
      };
      netcdf = final.callPackage netcdf.override { };
      adios2 = final.callPackage adios2.override { };
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vtk";
  version = "9.4.2";

  srcs =
    [
      (fetchurl {
        url = "https://www.vtk.org/files/release/${lib.versions.majorMinor finalAttrs.version}/VTK-${finalAttrs.version}.tar.gz";
        hash = "sha256-NsmODalrsSow/lNwgJeqlJLntm1cOzZuHI3CUeKFagI=";
      })
    ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      (fetchurl {
        url = "https://www.vtk.org/files/release/${lib.versions.majorMinor finalAttrs.version}/VTKData-${finalAttrs.version}.tar.gz";
        hash = "sha256-Hgqj32POOXXSnutmmF/DczMIJPkMKZG+UpUa0qgkGxE=";
      })
    ];

  patches = [
    (fetchpatch2 {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/vtk/-/raw/b4d07bd7ee5917e2c32f7f056cf78472bcf1cec2/netcdf-4.9.3.patch?full_index=1";
      hash = "sha256-h1NVeLuwAj7eUG/WSvrpXN9PtpjFQ/lzXmJncwY0r7w=";
    })
  ];

  postPatch =
    ''
      substituteInPlace GUISupport/QtQuick/Testing/Cxx/CMakeLists.txt \
        --replace-fail \
        ''\'''${VTK_QML_DIR}' \
        ''\'''$ENV{QML2_IMPORT_PATH}:''${VTK_QML_DIR}'
    ''
    # While char_traits<uint8_t> is not officially supported by any C++
    # standard, gcc and libcxx(<19) have extensions to support the type. The
    # C++20 standard introduces support for char_traits<char8_t>.
    # Starting with libcxx-19, the extensions to support char_traits<T> where
    # T is not a type specified by a C++ standard has been dropped. See
    # https://reviews.llvm.org/D138307 for details.
    + lib.optionalString stdenv.cc.isClang ''
      substituteInPlace IO/Geometry/vtkGLTFDocumentLoaderInternals.cxx \
        --replace-fail "return value == extensionUsedByModel;" "return value == extensionUsedByModel.get<std::string>();" \
        --replace-fail "return value == extensionRequiredByModel;" "return value == extensionRequiredByModel.get<std::string>();"

      echo "vtk_module_set_properties(VTK::ParallelDIY CXX_STANDARD 20)" >> Parallel/DIY/CMakeLists.txt
      echo "vtk_module_set_properties(VTK::FiltersExtraction CXX_STANDARD 20)" >> Filters/Extraction/CMakeLists.txt
    '';

  nativeBuildInputs = [ cmake ] ++ lib.optional enablePython python3Packages.python;

  buildInputs =
    [
      fmt
      eigen
      exprtk
      utf8cpp
      verdict
      nlohmann_json
      double-conversion

      # common data libraries
      lz4
      xz
      zlib
      pugixml
      expat
      jsoncpp
      libxml2

      # io modules
      ffmpeg
      libjpeg
      libpng
      libtiff
      proj
      sqlite
      libogg
      libharu
      libtheora
      vtkPackages.hdf5
      vtkPackages.netcdf
      vtkPackages.adios2
      opencascade-occt

      # rendering
      freetype
      vtkPackages.qttools
      vtkPackages.qtdeclarative
    ]
    ++ lib.optional mpiSupport mpi
    ++ lib.optional stdenv.hostPlatform.isLinux tbb_2022_0;

  propagatedBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libXcursor
      gl2ps
      libGL
    ]
    # create meta package providing dist-info for python3Pacakges.vtk that common cmake build does not do
    ++ lib.optionals enablePython [
      (python3Packages.mkPythonMetaPackage {
        inherit (finalAttrs) pname version meta;
        dependencies =
          with python3Packages;
          [
            numpy
            matplotlib
          ]
          ++ lib.optional mpiSupport (mpi4py.override { inherit mpi; });
      })
    ];

  cmakeFlags =
    [
      "-Wno-dev"
      (lib.cmakeBool "VTK_VERSIONED_INSTALL" false)
      (lib.cmakeBool "VTK_USE_MPI" mpiSupport)
      (lib.cmakeBool "VTK_USE_EXTERNAL" true)
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_fast_float" false) # required version incompatible
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_pegtl" false) # required version incompatible
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_cgns" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_ioss" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_token" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_gl2ps" (!stdenv.hostPlatform.isDarwin)) # External gl2ps causes failure linking to macOS OpenGL.framework
      (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_IOOCCT" "YES")
      (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_IOADIOS2" "YES")
      (lib.cmakeFeature "VTK_MODULE_ENABLE_VTK_IOFFMPEG" "YES")
      (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
      (lib.cmakeFeature "VTK_GROUP_ENABLE_Qt" "YES")
      (lib.cmakeFeature "VTK_QT_VERSION" (toString qtVersion))
      # `VTK_SMP_IMPLEMENTATION_TYPE` can be used to select one of Sequential, OpenMP, TBB, and STDThread.
      (lib.cmakeFeature "VTK_SMP_IMPLEMENTATION_TYPE" (
        if stdenv.hostPlatform.isDarwin then "STDThread" else "TBB"
      ))
    ]
    ++ lib.optionals enablePython [
      (lib.cmakeBool "VTK_WRAP_PYTHON" true)
      (lib.cmakeBool "VTK_BUILD_PYI_FILES" true)
      (lib.cmakeFeature "VTK_PYTHON_VERSION" "3")
    ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      (lib.cmakeFeature "VTK_BUILD_TESTING" "ON")
    ];

  env = {
    QML2_IMPORT_PATH = "${lib.getBin vtkPackages.qtdeclarative}/${vtkPackages.qtbase.qtQmlPrefix}";
  };

  preCheck = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchelf --add-rpath ${lib.getLib libGL}/lib lib/libvtkglad${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  __darwinAllowLocalNetworking = finalAttrs.finalPackage.doCheck;

  nativeCheckInputs = [
    cli11
    ctestCheckHook
    nixGLMesaHook
    headlessDisplayCheckHook
  ] ++ lib.optional mpiSupport mpiCheckPhaseHook;

  # Test results may vary across platforms; we primarily support x86_64-linux
  doCheck = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux;

  disabledTests = [
    # flaky tests
    "VTK::GUISupportQtQuickCxx-TestQQuickVTKRenderItem"
    "VTK::GUISupportQtQuickCxx-TestQQuickVTKRenderItemWidget"
    "VTK::GUISupportQtQuickCxx-TestQQuickVTKRenderWindow"
    "VTK::InteractionWidgetsPython-TestTensorWidget2"
    "VTK::FiltersCellGridCxx-TestCellGridEvaluator"
    # caught SIGSEGV/SIGTERM in mpiexec
    "VTK::FiltersParallelCxx-MPI-DistributedData"
    "VTK::FiltersParallelCxx-MPI-DistributedDataRenderPass"
    # vtkShaderProgram.cxx:1145   ERR| vtkShaderProgram (0x1375050): Could not create shader object.
    "VTK::RenderingOpenGL2Cxx-TestFluidMapper"
    "VTK::RenderingOpenGL2Cxx-TestGlyph3DMapperPickability"
  ];

  # byte-compile python modules since the CMake build does not do it
  postInstall = lib.optionalString enablePython ''
    python -m compileall -s $out $out/${python3Packages.python.sitePackages}
  '';

  dontWrapQtApps = true;

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    patchelf --add-rpath ${lib.getLib libGL}/lib $out/lib/libvtkglad${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  passthru = {
    inherit
      qtVersion
      enablePython
      mpiSupport
      vtkPackages
      ;
  };

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      tfmoraes
      qbisi
    ];
    platforms = lib.platforms.unix;
  };
})
