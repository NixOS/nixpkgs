{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jaraco-classes,
  jaraco-context,
  keyring,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "keyrings-alt";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "keyrings.alt";
    tag = "v${version}";
    hash = "sha256-m/hIXjri3FZ3rPIymiIBy8cKNOwJoj14WjsOyDtcWmU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    jaraco-classes
    jaraco-context
  ];

  nativeCheckInputs = [
    pytestCheckHook
    keyring
  ];

  pythonImportsCheck = [ "keyrings.alt" ];

  meta = {
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
    changelog = "https://github.com/jaraco/keyrings.alt/blob/v${version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyarly ];
  };
}
