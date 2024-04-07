{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfibaro";
  version = "0.7.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "rappenze";
    repo = "pyfibaro";
    rev = "refs/tags/${version}";
    hash = "sha256-jsl2Xc6bzN7SVyMnFeCwMpFUEa6xUWGn/T96MrDXlCE=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pyfibaro" ];

  meta = with lib; {
    description = "Library to access FIBARO Home center";
    homepage = "https://github.com/rappenze/pyfibaro";
    changelog = "https://github.com/rappenze/pyfibaro/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
