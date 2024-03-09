{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, boto
, inflection
, requests
, six
, urllib3
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qds-sdk";
  version = "1.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qubole";
    repo = "qds-sdk-py";
    rev = "refs/tags/V${version}";
    hash = "sha256-8aPIE2E3Fy2EiBM2FPRyjnJolIBdOzafI3Fvlod5hxU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    boto
    inflection
    requests
    six
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook mock ];

  pythonImportsCheck = [
    "qds_sdk"
  ];

  meta = with lib; {
    description = "A Python module that provides the tools you need to authenticate with, and use the Qubole Data Service API";
    homepage = "https://github.com/qubole/qds-sdk-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ shahrukh330 ];
    mainProgram = "qds.py";
  };
}
