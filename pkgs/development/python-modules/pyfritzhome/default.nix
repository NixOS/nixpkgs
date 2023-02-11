{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, nose
, mock
}:

buildPythonPackage rec {
  pname = "pyfritzhome";
  version = "0.6.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    rev = version;
    hash = "sha256-cRG+Dm3KG6no3/OQCZkvISW1yE5azdDVTa5oTV1sRpk=";
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    mock
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "pyfritzhome"
  ];

  meta = with lib; {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    homepage = "https://github.com/hthiery/python-fritzhome";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
