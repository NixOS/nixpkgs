{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-json-logger";
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "nhairs";
    repo = "python-json-logger";
    rev = "refs/tags/v${version}";
    hash = "sha256-dM9/ehPY/BnJSNBq1BiTUpJRigdzbGb3jD8Uhx+hmKc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pythonjsonlogger" ];

  meta = with lib; {
    description = "Json Formatter for the standard python logger";
    homepage = "https://github.com/nhairs/python-json-logger";
    changelog = "https://github.com/nhairs/python-json-logger/releases/tag/v${version}";
    license = licenses.bsdOriginal;
    maintainers = [ ];
  };
}
