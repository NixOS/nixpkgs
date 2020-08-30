{ lib, buildPythonPackage, fetchPypi, isPy27
, pkg-config, alsaLib, libjack2, tox, flake8, alabaster
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.4.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3dd1909d0f44f03a4191131f1829cac2ee6a94f5a4be2a9606354748e594e704";
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
