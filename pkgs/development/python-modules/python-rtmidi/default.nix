{ lib, buildPythonPackage, fetchPypi, isPy27
, pkg-config, alsaLib, libjack2, tox, flake8, alabaster
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.4.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f4bbcd77431917503d6ae738093c8419ed67812d50883fa9cfefce1eb21eb3a";
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
