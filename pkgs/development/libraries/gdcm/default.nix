{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  enableVTK ? true,
  vtk,
  DarwinTools, # sw_vers
  enablePython ? false,
  python ? null,
  swig,
  expat,
  libuuid,
  openjpeg,
  zlib,
  pkg-config,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if enablePython then "python-gdcm" else "gdcm";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "malaterre";
    repo = "GDCM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V1UPfRlNIDZa/N9wQ6wu8uCFH6bw8Y6jomy7BB4SNEA=";
  };

  patches = [
    ./add-missing-losslylosslessarray-in-TestTransferSyntax.patch
    # Fix vtk deprecated api, See https://docs.vtk.org/en/latest/release_details/9.3.html#id13.
    # Upstream mailing list: https://sourceforge.net/p/gdcm/mailman/message/59197515.
    ./fix-vtk-deprecated-api.patch
  ];

  cmakeFlags = [
    "-DGDCM_BUILD_APPLICATIONS=ON"
    "-DGDCM_BUILD_SHARED_LIBS=ON"
    "-DGDCM_BUILD_TESTING=ON"
    "-DGDCM_USE_SYSTEM_EXPAT=ON"
    "-DGDCM_USE_SYSTEM_ZLIB=ON"
    "-DGDCM_USE_SYSTEM_UUID=ON"
    "-DGDCM_USE_SYSTEM_OPENJPEG=ON"
    # hack around usual "`RUNTIME_DESTINATION` must not be an absolute path" issue:
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals enableVTK [
    "-DGDCM_USE_VTK=ON"
  ]
  ++ lib.optionals enablePython [
    "-DGDCM_WRAP_PYTHON:BOOL=ON"
    "-DGDCM_INSTALL_PYTHONMODULE_DIR=${placeholder "out"}/${python.sitePackages}/python_gdcm"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin DarwinTools;

  buildInputs = [
    expat
    libuuid
    openjpeg
    zlib
  ]
  ++ lib.optionals enableVTK [
    vtk
  ]
  ++ lib.optionals enablePython [
    swig
    python
  ];

  postInstall = lib.optionalString enablePython ''
    substitute \
      ${./python_gdcm.egg-info} \
      $out/${python.sitePackages}/python_gdcm-${finalAttrs.version}.egg-info \
      --subst-var-by GDCM_VER "${finalAttrs.version}"
  '';

  disabledTests = [
    # require networking:
    "TestEcho"
    "TestFind"
    "gdcmscu-echo-dicomserver"
    "gdcmscu-find-dicomserver"
    # seemingly ought to be disabled when the test data submodule is not present:
    "TestvtkGDCMImageReader2_3"
    "TestSCUValidation"
    # errors because 3 classes not wrapped:
    "TestWrapPython"
    # AttributeError: module 'gdcm' has no attribute 'UIDGenerator_SetRoot'; maybe a wrapping regression:
    "TestUIDGeneratorPython"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    "TestRescaler2"
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  doCheck = true;
  # note that when the test data is available to the build via `fetchSubmodules = true`,
  # a number of additional but much slower tests are enabled

  meta = {
    description = "Grassroots cross-platform DICOM implementation";
    longDescription = ''
      Grassroots DICOM (GDCM) is an implementation of the DICOM standard designed to be open source so that researchers may access clinical data directly.
      GDCM includes a file format definition and a network communications protocol, both of which should be extended to provide a full set of tools for a researcher or small medical imaging vendor to interface with an existing medical database.
    '';
    homepage = "https://gdcm.sourceforge.net";
    license = with lib.licenses; [
      bsd3
      asl20
    ];
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.all;
  };
})
