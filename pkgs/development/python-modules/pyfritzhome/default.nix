{ lib, buildPythonPackage, fetchPypi, pythonOlder
, requests
, nose, mock }:

buildPythonPackage rec {
  pname = "pyfritzhome";
  version = "0.4.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
   inherit pname version;
   sha256 = "0ncyv8svw0fhs01ijjkb1gcinb3jpyjvv9xw1bhnf4ri7b27g6ww";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    mock
    nose
  ];

  checkPhase = ''
    nosetests --with-coverage
  '';

  meta = with lib; {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    homepage = "https://github.com/hthiery/python-fritzhome";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
