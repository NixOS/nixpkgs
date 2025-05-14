{
  buildOctavePackage,
  lib,
  fetchurl,
  instrument-control,
  arduino-core-unwrapped,
}:

buildOctavePackage rec {
  pname = "arduino";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-p9SDTXkIwnrkNXeVhzAHks7EL4NdwBokrH2j9hqAJqQ=";
  };

  requiredOctavePackages = [
    instrument-control
  ];

  propagatedBuildInputs = [
    arduino-core-unwrapped
  ];

  meta = {
    name = "Octave Arduino Toolkit";
    homepage = "https://gnu-octave.github.io/packages/arduino/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Basic Octave implementation of the matlab arduino extension, allowing communication to a programmed arduino board to control its hardware";
  };
}
