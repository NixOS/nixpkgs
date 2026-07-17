{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vtk,
  gdcm,
  testers,
  vtk-dicom,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtk-dicom";
  version = "0.8.17";

  src = fetchFromGitHub {
    owner = "dgobbi";
    repo = "vtk-dicom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1lI2qsV4gymWqjeouEHZ5FRlmlh9vimH7J5rzA+eOds=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    vtk
    gdcm
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_GDCM" true)
    (lib.cmakeBool "DICOM_VERSIONED_INSTALL" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck [
    # vtkBool does not accept TRUE, we have to use STRING "ON"
    (lib.cmakeFeature "BUILD_TESTING" "ON")
  ];

  doCheck = true;

  passthru.tests = {
    python = vtk-dicom.override {
      vtk = vtk.override { pythonSupport = true; };
    };

    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "DICOM" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "DICOM for VTK";
    homepage = "https://github.com/dgobbi/vtk-dicom";
    changelog = "https://github.com/dgobbi/vtk-dicom/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      qbisi
      bcdarwin
    ];
    platforms = lib.platforms.unix;
  };
})
