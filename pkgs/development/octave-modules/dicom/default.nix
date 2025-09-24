{
  buildOctavePackage,
  lib,
  fetchurl,
  gdcm,
  cmake,
}:

buildOctavePackage rec {
  pname = "dicom";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-erUZudOknymgGprqUhCaSvN/WlmWZ1qgH8HDYrNOg2I=";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    gdcm
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/dicom/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Digital communications in medicine (DICOM) file io";
  };
}
