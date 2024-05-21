{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pydexcom";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gagebenne";
    repo = "pydexcom";
    rev = "refs/tags/${version}";
    hash = "sha256-46+Ml73F6EUbMwRJB93FD+No/g65RJwnCnFzH4Pb5ek=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
  ];

  # Tests are interacting with the Dexcom API
  doCheck = false;

  pythonImportsCheck = [
    "pydexcom"
  ];

  meta = with lib; {
    description = "Python API to interact with Dexcom Share service";
    homepage = "https://github.com/gagebenne/pydexcom";
    changelog = "https://github.com/gagebenne/pydexcom/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
