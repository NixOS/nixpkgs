{ stdenv, fetchurl, cmake, vtk_7, darwin
, enablePython ? false, python ? null,  swig ? null}:

stdenv.mkDerivation rec {
  version = "3.0.7";
  pname = "gdcm";

  src = fetchurl {
    url = "mirror://sourceforge/gdcm/${pname}-${version}.tar.bz2";
    sha256 = "1mm1190fv059k2vrilh3znm8z1ilygwld1iazdgh5s04mi1qljni";
  };

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-DGDCM_BUILD_APPLICATIONS=ON"
    "-DGDCM_BUILD_SHARED_LIBS=ON"
    "-DGDCM_USE_VTK=ON"
  ]
  ++ stdenv.lib.optional enablePython [
    "-DGDCM_WRAP_PYTHON:BOOL=ON"
    "-DGDCM_INSTALL_PYTHONMODULE_DIR=${placeholder "out"}/${python.sitePackages}"
  ];

  preConfigure = ''
    cmakeDir=$PWD
    mkdir ../build
    cd ../build
  '';

  enableParallelBuilding = true;
  buildInputs = [ cmake vtk_7 ]
    ++ stdenv.lib.optional stdenv.isDarwin [
      darwin.apple_sdk.frameworks.ApplicationServices
      darwin.apple_sdk.frameworks.Cocoa
    ] ++ stdenv.lib.optional enablePython [ swig python ];
  propagatedBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "The grassroots cross-platform DICOM implementation";
    longDescription = ''
      Grassroots DICOM (GDCM) is an implementation of the DICOM standard designed to be open source so that researchers may access clinical data directly.
      GDCM includes a file format definition and a network communications protocol, both of which should be extended to provide a full set of tools for a researcher or small medical imaging vendor to interface with an existing medical database.
    '';
    homepage = "http://gdcm.sourceforge.net/";
    license = with licenses; [ bsd3 asl20 ];
    platforms = platforms.all;
  };
}
