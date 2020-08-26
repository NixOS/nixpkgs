{ lib, buildPythonPackage, fetchPypi, isPy27
, pkg-config, alsaLib, libjack2, tox, flake8, alabaster
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.4.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3721ed3643f407cd96ad377cff0c2e28f2e8df0abbbe15a8a9668daae0b2b743";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsaLib libjack2 ];
  checkInputs = [
    tox
    flake8
    alabaster
  ];

  meta = with lib; {
    description = "A Python binding for the RtMidi C++ library implemented using Cython";
    homepage = "https://chrisarndt.de/projects/python-rtmidi/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
