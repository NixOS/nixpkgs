{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyexpect";
  version = "1.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dwt";
    repo = "pyexpect";
    tag = version;
    hash = "sha256-2c+lIpw1q5vF/+7oaVpu743n+xxzf23wXce8oFA7jKw=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pyexpect" ];

  meta = {
    changelog = "https://dwt/pyexpect/releases/tag/${version}";
    description = "Minimal but very flexible implementation of the expect pattern";
    homepage = "https://github.com/dwt/pyexpect";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ lzcunt ];
  };
}
