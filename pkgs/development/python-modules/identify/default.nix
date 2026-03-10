{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cffi,
  setuptools,
  ukkonen,
}:

buildPythonPackage (finalAttrs: {
  pname = "identify";
  version = "2.6.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hnVG1TRkq605uFk3PmzqFwnzcYru/4OYbrJYAtDuo0g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cffi
    pytestCheckHook
    ukkonen
  ];

  pythonImportsCheck = [ "identify" ];

  meta = {
    description = "File identification library for Python";
    homepage = "https://github.com/pre-commit/identify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "identify-cli";
  };
})
