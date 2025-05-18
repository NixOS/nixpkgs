{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  pytestCheckHook,
  pexpect,
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-timeout";
    tag = version;
    hash = "sha256-NGTy3Hua6yEMWXQDJQO2Z5DD3clXTZXEH6DNQBMSGtQ=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    pexpect
  ];

  pythonImportsCheck = [ "pytest_timeout" ];

  meta = with lib; {
    description = "Pytest plugin to abort hanging tests";
    homepage = "https://github.com/pytest-dev/pytest-timeout/";
    changelog = "https://github.com/pytest-dev/pytest-timeout/tree/${src.tag}#changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
