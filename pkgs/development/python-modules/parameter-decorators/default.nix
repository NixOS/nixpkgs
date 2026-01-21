{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "parameter-decorators";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matan1008";
    repo = "parameter-decorators";
    tag = "v${version}";
    hash = "sha256-ZTgUsBc2ArnRPR4k0Od2A571iFfu+oupCxEqzk2cTUQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "parameter_decorators" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/matan1008/parameter-decorators/releases/tag/${src.tag}";
    description = "Handy decorators for converting parameters";
    homepage = "https://github.com/matan1008/parameter-decorators";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
