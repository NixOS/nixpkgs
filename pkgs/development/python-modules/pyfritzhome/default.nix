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
  version = "0.6.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    rev = version;
    sha256 = "sha256-CEoXb7D/8Iksw4aJYNqANkmfhd0yxIIuabaTdWI3RNc=";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [
    mock
    nose
  ];

  checkPhase = ''
    nosetests --with-coverage
  '';

  pythonImportsCheck = [ "pyfritzhome" ];

  meta = with lib; {
    description = "Python Library to access AVM FRITZ!Box homeautomation";
    homepage = "https://github.com/hthiery/python-fritzhome";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
