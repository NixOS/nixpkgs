{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  packaging,
}:

buildPythonPackage rec {
  pname = "requirements-parser";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "madpah";
    repo = "requirements-parser";
    tag = "v${version}";
    hash = "sha256-Hti1r/OLYHue+c7/TDDRzBgKxJazobZG+aFxK2ok70g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requirements" ];

  meta = {
    description = "Pip requirements file parser";
    homepage = "https://github.com/davidfischer/requirements-parser";
    changelog = "https://github.com/madpah/requirements-parser/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
}
