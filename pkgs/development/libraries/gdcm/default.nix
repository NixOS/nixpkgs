{ stdenv, fetchurl, cmake, vtk, darwin }:

stdenv.mkDerivation rec {
  version = "3.0.5";
  pname = "gdcm";

  src = fetchurl {
    url = "mirror://sourceforge/gdcm/${pname}-${version}.tar.bz2";
    sha256 = "16d3sf81n4qhwbbx1d80jg6fhrla5paan384c4bbbqvbhm222yby";
  };

  dontUseCmakeBuildDir = true;
  preConfigure = ''
    cmakeDir=$PWD
    mkdir ../build
    cd ../build
  '';

  cmakeFlags = [
    "-DGDCM_BUILD_APPLICATIONS=ON"
    "-DGDCM_BUILD_SHARED_LIBS=ON"
    "-DGDCM_USE_VTK=ON"
  ];

  enableParallelBuilding = true;
  buildInputs = [ cmake vtk ] ++ stdenv.lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.ApplicationServices darwin.apple_sdk.frameworks.Cocoa ];
  propagatedBuildInputs = [ ];

  meta = with stdenv.lib; {
    description = "The grassroots cross-platform DICOM implementation";
    longDescription = ''
      Grassroots DICOM (GDCM) is an implementation of the DICOM standard designed to be open source so that researchers may access clinical data directly.
      GDCM includes a file format definition and a network communications protocol, both of which should be extended to provide a full set of tools for a researcher or small medical imaging vendor to interface with an existing medical database.
    '';
    homepage = http://gdcm.sourceforge.net/;
    license = with licenses; [ bsd3 asl20 ];
    platforms = platforms.all;
  };
}

