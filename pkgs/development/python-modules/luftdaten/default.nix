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
  version = "0.7.0";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-luftdaten";
    rev = version;
    sha256 = "0ij56zmdxwlqla11ii32nrv0fxd96d9m7q4bzlkrvw5hkp9lvrqq";
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
    maintainers = with maintainers; [ dotlambda ];
  };
}
