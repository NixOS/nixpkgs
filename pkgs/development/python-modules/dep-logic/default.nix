{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pdm-backend,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dep-logic";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "dep-logic";
    tag = version;
    hash = "sha256-BjqPtfYsHSDQoaYs+hB0r/mRuONqBHOb6goi1dxkFWo=";
  };

  nativeBuildInputs = [ pdm-backend ];

  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dep_logic" ];

  meta = {
    changelog = "https://github.com/pdm-project/dep-logic/releases/tag/${src.tag}";
    description = "Python dependency specifications supporting logical operations";
    homepage = "https://github.com/pdm-project/dep-logic";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tomasajt
      misilelab
    ];
  };
}
