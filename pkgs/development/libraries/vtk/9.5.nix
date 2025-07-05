{
  lib,
  newScope,
  stdenv,
  fetchurl,
  fetchpatch2,
  cmake,
  pkg-config,

  # common dependencies
  tk,
  mpi,
  python3Packages,
  catalyst,
  cli11,
  boost,
  eigen,
  verdict,
  double-conversion,

  # common data libraries
  lz4,
  xz,
  zlib,
  pugixml,
  expat,
  jsoncpp,
  libxml2,
  exprtk,
  utf8cpp,
  libarchive,
  nlohmann_json,

  # filters
  openturns,
  openslide,

  # io modules
  adios2,
  libLAS,
  libgeotiff,
  laszip_2,
  gdal,
  pdal,
  alembic,
  imath,
  openvdb,
  c-blosc,
  unixODBC,
  postgresql,
  libmysqlclient,
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
  opencascade-occt,

  # threading
  tbb,

  # rendering
  freetype,
  fontconfig,
  libX11,
  libXfixes,
  libXrender,
  libXcursor,
  gl2ps,
  libGL,
  libGLU,
  libglut,
  qt5,
  qt6,

  # check
  ctestCheckHook,
  headlessDisplayHook,
  mpiCheckPhaseHook,

  # custom options
  withQt5 ? false,
  withQt6 ? false,
  # To avoid conflicts between the propagated vtkPackages.hdf5
  # and the input hdf5 used by most downstream packages,
  # we set mpiSupport to false by default.
  mpiSupport ? false,
  pythonSupport ? false,

  # passthru.tests
  testers,
}:
let
  qtPackages =
    if withQt6 then
      qt6
    else if withQt5 then
      qt5
    else
      null;
  vtkPackages = lib.makeScope newScope (self: {
    inherit
      tbb
      mpi
      mpiSupport
      python3Packages
      pythonSupport
      ;

    hdf5 = hdf5.override {
      inherit mpi mpiSupport;
      cppSupport = !mpiSupport;
    };
    openvdb = self.callPackage openvdb.override { };
    netcdf = self.callPackage netcdf.override { };
    catalyst = self.callPackage catalyst.override { };
    adios2 = self.callPackage adios2.override { };
  });
  vtkBool = feature: bool: lib.cmakeFeature feature "${if bool then "YES" else "NO"}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vtk";
  version = "9.5.0";

  srcs =
    [
      (fetchurl {
        url = "https://www.vtk.org/files/release/${lib.versions.majorMinor finalAttrs.version}/VTK-${finalAttrs.version}.tar.gz";
        hash = "sha256-BK6GJGuVV8a2GvvFNKbfCZJE+8jzk3+C5rwFcJU6+H0=";
      })
    ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      (fetchurl {
        url = "https://www.vtk.org/files/release/${lib.versions.majorMinor finalAttrs.version}/VTKData-${finalAttrs.version}.tar.gz";
        hash = "sha256-kc091jgkMOfKu+yJafLvD46csjylDnsKcBikKeZpXK8=";
      })
    ];

  patches = [
    # https://gitlab.kitware.com/vtk/vtk/-/issues/19699
    (fetchpatch2 {
      url = "https://gitlab.kitware.com/vtk/vtk/-/commit/6b4f7b853675c63e4831c366ca8f78e320c1bfb5.patch?full_index=1";
      hash = "sha256-7WJhUh4DRt9ZEf5+TVbb8swtmh0JL17BXhVVLiYTcpc=";
    })
    # https://gitlab.kitware.com/vtk/vtk/-/issues/19705
    (fetchpatch2 {
      url = "https://gitlab.kitware.com/vtk/vtk/-/commit/ce10dfe82ffa19c8108885625a6f8b3f980bed3b.patch?full_index=1";
      hash = "sha256-FVdL/raib6HwEk2sB3rkT2vSiCNjiFN93tYQqiP+R9Q=";
    })
  ];

  postPatch =
    # https://discourse.paraview.org/t/possible-race-condition-in-qvtkopenglnativewidget-initializegl/16823
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace GUISupport/Qt/QVTKOpenGLNativeWidget.cxx \
        --replace-fail "this->RenderWindow->SetOpenGLSymbolLoader(loadFunc, this->context());" ""
    '';

  nativeBuildInputs =
    [
      cmake
      pkg-config # required for finding MySQl
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.pythonImportsCheckHook
    ];

  buildInputs =
    [
      libLAS
      libgeotiff
      laszip_2
      gdal
      pdal
      alembic
      imath
      c-blosc
      unixODBC
      postgresql
      libmysqlclient
      ffmpeg
      opencascade-occt
      fontconfig
      openturns
      libarchive
      libGL
      vtkPackages.openvdb
    ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      libGLU
      libglut
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libXfixes
      libXrender
      libXcursor
    ]
    ++ lib.optional (withQt5 || withQt6) qtPackages.qttools
    ++ lib.optional mpiSupport mpi
    ++ lib.optional pythonSupport tk;

  # propagated by vtk-config.cmake
  propagatedBuildInputs =
    [
      eigen
      boost
      verdict
      double-conversion
      freetype
      lz4
      xz
      zlib
      expat
      exprtk
      pugixml
      jsoncpp
      libxml2
      utf8cpp
      nlohmann_json
      libjpeg
      libpng
      libtiff
      proj
      sqlite
      libogg
      libharu
      libtheora
      cli11
      openslide
      vtkPackages.hdf5
      vtkPackages.adios2
      vtkPackages.netcdf
      vtkPackages.catalyst
      vtkPackages.tbb
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      gl2ps
    ]
    # create meta package providing dist-info for python3Pacakges.vtk that common cmake build does not do
    ++ lib.optionals pythonSupport [
      (python3Packages.mkPythonMetaPackage {
        inherit (finalAttrs) pname version meta;
        dependencies =
          with python3Packages;
          [
            numpy
            wslink
            matplotlib
          ]
          ++ lib.optional mpiSupport (mpi4py.override { inherit mpi; });
      })
    ];

  # wrapper script calls qmlplugindump, crashes due to lack of minimal platform plugin
  # Could not find the Qt platform plugin "minimal" in ""
  preConfigure = lib.optionalString withQt5 ''
    export QT_PLUGIN_PATH=${lib.getBin qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}
  '';

  env = {
    CMAKE_PREFIX_PATH = "${lib.getDev openvdb}/lib/cmake/OpenVDB";
    NIX_LDFLAGS = "-L${lib.getLib libmysqlclient}/lib/mariadb";
  };

  cmakeFlags =
    [
      (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")

      # vtk common configure options
      (lib.cmakeBool "VTK_DISPATCH_SOA_ARRAYS" true)
      (lib.cmakeBool "VTK_ENABLE_CATALYST" true)
      (lib.cmakeBool "VTK_WRAP_SERIALIZATION" true)
      (lib.cmakeBool "VTK_BUILD_ALL_MODULES" true)
      (lib.cmakeBool "VTK_VERSIONED_INSTALL" false)
      (lib.cmakeFeature "VTK_SMP_IMPLEMENTATION_TYPE" "TBB")

      # use system packages if possible
      (lib.cmakeBool "VTK_USE_EXTERNAL" true)
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_fast_float" false) # required version incompatible
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_pegtl" false) # required version incompatible
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_cgns" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_ioss" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_token" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_fmt" false) # prefer vendored fmt
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_scn" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_vtkviskores" false) # missing in nixpkgs
      (lib.cmakeBool "VTK_MODULE_USE_EXTERNAL_VTK_gl2ps" stdenv.hostPlatform.isLinux) # external gl2ps causes failure linking to macOS OpenGL.framework

      # Rendering
      (vtkBool "VTK_MODULE_ENABLE_VTK_RenderingRayTracing" false) # ospray
      (vtkBool "VTK_MODULE_ENABLE_VTK_RenderingOpenXR" false) # openxr
      (vtkBool "VTK_MODULE_ENABLE_VTK_RenderingOpenVR" false) # openvr
      (vtkBool "VTK_MODULE_ENABLE_VTK_RenderingAnari" false) # anari

      # qtSupport
      (vtkBool "VTK_GROUP_ENABLE_Qt" (withQt6 || withQt5))
      (lib.cmakeFeature "VTK_QT_VERSION" "Auto") # will search for Qt6 first

      # pythonSupport
      (lib.cmakeBool "VTK_USE_TK" pythonSupport)
      (vtkBool "VTK_GROUP_ENABLE_Tk" pythonSupport)
      (lib.cmakeBool "VTK_WRAP_PYTHON" pythonSupport)
      (lib.cmakeBool "VTK_BUILD_PYI_FILES" pythonSupport)
      (lib.cmakeFeature "VTK_PYTHON_VERSION" "3")

      # mpiSupport
      (lib.cmakeBool "VTK_USE_MPI" mpiSupport)
      (vtkBool "VTK_GROUP_ENABLE_MPI" mpiSupport)
    ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [
      (lib.cmakeFeature "VTK_BUILD_TESTING" "ON")
    ];

  preCheck =
    lib.optionalString (withQt5 || withQt6) ''
      export QML2_IMPORT_PATH=${lib.getBin qtPackages.qtdeclarative}/${qtPackages.qtbase.qtQmlPrefix}
    ''
    # libvtkglad.so will find and load libGL.so at runtime.
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-rpath ${lib.getLib libGL}/lib lib/libvtkglad.so
    '';

  nativeCheckInputs = [
    ctestCheckHook
    headlessDisplayHook
  ] ++ lib.optional mpiSupport mpiCheckPhaseHook;

  # tests are done in passthru.tests.withCheck
  doCheck = false;

  # byte-compile python modules since the CMake build does not do it
  postInstall = lib.optionalString pythonSupport ''
    python -m compileall -s $out $out/${python3Packages.python.sitePackages}
  '';

  pythonImportsCheck = [ "vtk" ];

  dontWrapQtApps = true;

  postFixup =
    # Remove thirdparty find module that have been provided in nixpkgs
    ''
      rm -rf $out/lib/cmake/vtk/patches
      rm $out/lib/cmake/vtk/Find{double-conversion,EXPAT,Freetype,utf8cpp,LibXml2,FontConfig}.cmake
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --add-rpath ${lib.getLib libGL}/lib $out/lib/libvtkglad.so
    '';

  passthru = {
    inherit
      pythonSupport
      mpiSupport
      ;

    vtkPackages = vtkPackages.overrideScope (
      final: prev: {
        vtk = finalAttrs.finalPackage;
      }
    );

    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        moduleNames = [ "VTK" ];

        package = finalAttrs.finalPackage;

        nativeBuildInputs = lib.optionals (withQt5 || withQt6) [
          qtPackages.qttools
          qtPackages.wrapQtAppsHook
        ];
      };
      # Most checks on the Darwin platform fail with:
      #   Terminating app due to uncaught exception 'NSInternalInconsistencyException',
      #   reason: 'Critical error: required built-in appearance SystemAppearance not found'.
      # This is possibly due to the Nix sandbox restricting access to system resources, e.g.:
      #   /System/Library/CoreServices/SystemAppearance.bundle
      #   /System/Library/Frameworks/OpenGL.framework/OpenGL
      withCheck = lib.optionalAttrs stdenv.hostPlatform.isLinux (
        finalAttrs.finalPackage.overrideAttrs {
          doCheck = true;

          disabledTests = [
            # ERR| vtkXOpenGLRenderWindow (0x2233a60): Could not find a decent config
            "VTK::RenderingOpenGL2Cxx-TestFluidMapper"
            # the test fails and is visually not acceptable
            "VTK::RenderingExternalCxx-TestGLUTRenderWindow"
            # the test fails but is visually acceptable
            "VTK::InteractionWidgetsPython-TestTensorWidget2"
            # outputs uniform font style throughout (expect regular, italic, bold, bold-italic)
            "VTK::RenderingFreeTypeFontConfigCxx-TestSystemFontRendering"
          ];
        }
      );
    };
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = "https://www.vtk.org/";
    changelog = "https://docs.vtk.org/en/latest/release_details/${lib.versions.majorMinor finalAttrs.version}.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
    platforms = lib.platforms.unix;
  };
})
