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
  version = "2.6.14";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    tag = "v${version}";
    hash = "sha256-l486vlvhDEm9f11z1FDB9AxAbQ+jgHvGppn4CTc/dLk=";
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
