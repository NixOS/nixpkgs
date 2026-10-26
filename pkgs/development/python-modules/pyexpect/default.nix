{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyexpect";
  version = "1.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dwt";
    repo = "pyexpect";
    tag = finalAttrs.version;
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
    changelog = "https://github.com/dwt/pyexpect/releases/tag/${finalAttrs.version}";
    description = "Minimal but very flexible implementation of the expect pattern";
    homepage = "https://github.com/dwt/pyexpect";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ lzcunt ];
  };
})
