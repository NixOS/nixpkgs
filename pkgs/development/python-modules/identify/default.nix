{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  cffi,
  setuptools,
  ukkonen,
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.6.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    tag = "v${version}";
    hash = "sha256-Du96uRQCymduvAruHSgjKv/OrDIPaMwPU+x/OTchERQ=";
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
}
