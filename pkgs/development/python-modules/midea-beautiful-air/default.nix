{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  requests,
  pytestCheckHook,
  pytest-socket,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "midea-beautiful-air";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbogojevic";
    repo = "midea-beautiful-air";
    tag = "v${version}";
    hash = "sha256-786Q085bv8Zsm0c55I4XalRhEfwElRTJds5qnb0cWhk=";
  };

  build-system = [ setuptools ];

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
