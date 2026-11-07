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
  version = "2.6.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DWaCz1Veyg7SJLY1JbiGKz0QpxmYUtK1ru6aFdFfwbY=";
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
