{ stdenv, fetchurl, cmake, vtk }:

stdenv.mkDerivation rec {
  version = "2.8.9";
  name = "gdcm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/gdcm/${name}.tar.bz2";
    sha256 = "1za252d1chv40d78bkjngrg1p2yx0vya8y9q3vqmz66ip2zilvx7";
  };

  dontUseCmakeBuildDir = true;
  preConfigure = ''
    cmakeDir=$PWD
    mkdir ../build
    cd ../build
  '';

  cmakeFlags = ''
    -DGDCM_BUILD_APPLICATIONS=ON
    -DGDCM_BUILD_SHARED_LIBS=ON
    -DGDCM_USE_VTK=ON
  '';

  enableParallelBuilding = true;
  buildInputs = [ cmake vtk ];
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

