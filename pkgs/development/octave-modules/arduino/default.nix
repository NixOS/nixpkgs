{ buildOctavePackage
, lib
, fetchurl
, instrument-control
, arduino
}:

buildOctavePackage rec {
  pname = "arduino";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0r0bcq2zkwba6ab6yi6czbhrj4adm9m9ggxmzzcd9h40ckqg6wjv";
  };

  requiredOctavePackages = [
    instrument-control
  ];

  # Might be able to use pkgs.arduino-core
  propagatedBuildInputs = [
    arduino
  ];

  meta = with lib; {
    name = "Octave Arduino Toolkit";
    homepage = "https://octave.sourceforge.io/arduino/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Basic Octave implementation of the matlab arduino extension, allowing communication to a programmed arduino board to control its hardware";
  };
}
