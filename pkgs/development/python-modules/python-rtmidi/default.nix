{ lib, buildPythonPackage, fetchPypi, isPy27
, pkg-config, alsaLib, libjack2, tox, flake8, alabaster
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.4.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aqhsl9w3h0rwf3mhr8parjbxm2sb6sn5mac6725cvm535pqqyhz";
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
