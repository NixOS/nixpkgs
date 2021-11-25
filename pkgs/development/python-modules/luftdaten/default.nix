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
  version = "0.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-luftdaten";
    rev = version;
    sha256 = "sha256-76Y5TJet0WtzYXuK8Og0rmpsUIlXK7b37oesh+MliU8=";
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
