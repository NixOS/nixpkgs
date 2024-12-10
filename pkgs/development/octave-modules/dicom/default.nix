{
  buildOctavePackage,
  lib,
  fetchurl,
  gdcm,
  cmake,
}:

buildOctavePackage rec {
  pname = "dicom";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-CFspqPJDSU1Pg+o6dub1/+g+mPDps9sPlus6keDj6h0=";
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
