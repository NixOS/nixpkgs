{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, httpx
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "luftdaten";
  version = "0.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-luftdaten";
    rev = version;
    sha256 = "sha256-tYaY/F4mdO5k+Oj+RkNFWP8xqh1xuDyoAKBFzAhamkA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "luftdaten" ];

  meta = with lib; {
    description = "Python API for interacting with luftdaten.info";
    homepage = "https://github.com/home-assistant-ecosystem/python-luftdaten";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda fab ];
  };
}
