{ buildOctavePackage
, lib
, fetchurl
, gdcm
, cmake
}:

buildOctavePackage rec {
  pname = "dicom";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "131wn6mrv20np10plirvqia8dlpz3g0aqi3mmn2wyl7r95p3dnza";
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
