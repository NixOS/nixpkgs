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
  version = "0.6.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "hthiery";
    repo = "python-fritzhome";
    rev = version;
    sha256 = "1wzys84hxrjcg86fcn7f7i2i6979qwcpny2afk5rvwljh8f7bli5";
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
