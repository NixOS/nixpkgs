{ lib
, stdenv
, fetchFromGitHub
, cmake
, enableVTK ? true
, vtk
, ApplicationServices
, Cocoa
, libiconv
, enablePython ? false
, python ? null
, swig
}:

stdenv.mkDerivation rec {
  pname = "gdcm";
  version = "3.0.21";

  src = fetchFromGitHub {
    owner = "malaterre";
    repo = "GDCM";
    rev = "refs/tags/v${version}";
    hash = "sha256-BmUJCqCGt+BvVpLG4bzCH4lsqmhWHU0gbOIU2CCIMGU=";
  };

  cmakeFlags = [
    "-DGDCM_BUILD_APPLICATIONS=ON"
    "-DGDCM_BUILD_SHARED_LIBS=ON"
    "-DGDCM_BUILD_TESTING=ON"
    # hack around usual "`RUNTIME_DESTINATION` must not be an absolute path" issue:
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals enableVTK [
    "-DGDCM_USE_VTK=ON"
  ] ++ lib.optionals enablePython [
    "-DGDCM_WRAP_PYTHON:BOOL=ON"
    "-DGDCM_INSTALL_PYTHONMODULE_DIR=${placeholder "out"}/${python.sitePackages}"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals enableVTK [
    vtk
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    Cocoa
    libiconv
  ] ++ lib.optionals enablePython [ swig python ];

  disabledTests = [
    # require networking:
    "TestEcho"
    "TestFind"
    "gdcmscu-echo-dicomserver"
    "gdcmscu-find-dicomserver"
    # seemingly ought to be be disabled when the test data submodule is not present:
    "TestvtkGDCMImageReader2_3"
    "TestSCUValidation"
    # errors because 3 classes not wrapped:
    "TestWrapPython"
  ];

  checkPhase = ''
    runHook preCheck
    ctest --exclude-regex '^(${lib.concatStringsSep "|" disabledTests})$'
    runHook postCheck
  '';
  doCheck = true;
  # note that when the test data is available to the build via `fetchSubmodules = true`,
  # a number of additional but much slower tests are enabled

  meta = with lib; {
    description = "The grassroots cross-platform DICOM implementation";
    longDescription = ''
      Grassroots DICOM (GDCM) is an implementation of the DICOM standard designed to be open source so that researchers may access clinical data directly.
      GDCM includes a file format definition and a network communications protocol, both of which should be extended to provide a full set of tools for a researcher or small medical imaging vendor to interface with an existing medical database.
    '';
    homepage = "https://gdcm.sourceforge.net/";
    license = with licenses; [ bsd3 asl20 ];
    maintainers = with maintainers; [ tfmoraes ];
    platforms = platforms.all;
  };
}
