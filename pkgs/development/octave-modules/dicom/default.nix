{ buildOctavePackage
, lib
, fetchurl
, gdcm
, cmake
}:

buildOctavePackage rec {
  pname = "dicom";
  version = "0.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-0qNqjpJWWBA0N5IgjV0e0SPQlCvbzIwnIgaWo+2wKw0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    gdcm
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/dicom/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Digital communications in medicine (DICOM) file io";
  };
}
