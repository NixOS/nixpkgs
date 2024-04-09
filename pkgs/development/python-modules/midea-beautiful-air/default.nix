{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, cryptography
, requests
, pytestCheckHook
, pytest-socket
, requests-mock
}:

buildPythonPackage rec {
  pname = "midea-beautiful-air";
  version = "0.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbogojevic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1IOv9K8f69iRpYaCx3k0smVrCKPmDxlT/1uVoTyvIjU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-socket
    requests-mock
  ];

  disabledTestPaths = [
    # tests optional dependencies + network
    "tests/test_cli.py"
  ];

  pythonImportsCheck = [ "midea_beautiful" ];

  meta = with lib; {
    description = "Python client for accessing Midea air conditioners and dehumidifiers (Midea, Comfee, Inventor EVO) via local network";
    homepage = "https://github.com/nbogojevic/midea-beautiful-air";
    changelog = "https://github.com/nbogojevic/midea-beautiful-air/releases/tag/v${version}";
    maintainers = with maintainers; [ k900 ];
    mainProgram = "midea-beautiful-air-cli";
    license = licenses.mit;
  };
}
