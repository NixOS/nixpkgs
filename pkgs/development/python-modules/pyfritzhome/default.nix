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
  version = "0.6.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    rev = version;
    sha256 = "1hwxq9w5qmiky8gpp623nabmydr3yv6hvgzk24fdbmkglfp6ja1v";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [
    mock
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [ "pyfritzhome" ];

  meta = with lib; {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    homepage = "https://github.com/hthiery/python-fritzhome";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
