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
  version = "0.4.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "dep-logic";
    rev = "refs/tags/${version}";
    hash = "sha256-5PEHkxwIgDz3Qs993qI4eaQZ5Him4i/MAnUam820AWc=";
  };

  nativeBuildInputs = [ pdm-backend ];

  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dep_logic" ];

  meta = {
    changelog = "https://github.com/pdm-project/dep-logic/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Python dependency specifications supporting logical operations";
    homepage = "https://github.com/pdm-project/dep-logic";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
