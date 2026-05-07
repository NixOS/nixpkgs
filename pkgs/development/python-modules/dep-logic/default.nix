{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dep-logic";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "dep-logic";
    tag = finalAttrs.version;
    hash = "sha256-BjqPtfYsHSDQoaYs+hB0r/mRuONqBHOb6goi1dxkFWo=";
  };

  nativeBuildInputs = [ pdm-backend ];

  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dep_logic" ];

  meta = {
    changelog = "https://github.com/pdm-project/dep-logic/releases/tag/${finalAttrs.src.tag}";
    description = "Python dependency specifications supporting logical operations";
    homepage = "https://github.com/pdm-project/dep-logic";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tomasajt
      misilelab
    ];
  };
})
