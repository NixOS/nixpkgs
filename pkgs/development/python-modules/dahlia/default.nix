{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dahlia";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dahlia-lib";
    repo = "dahlia";
    tag = version;
    hash = "sha256-489wI0SoC6EU9lC2ISYsLOJUC8g+kLA7UpOrDiBCBmo=";
  };

  build-system = [ hatchling ];
  pythonImportsCheck = [ "dahlia" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/dahlia-lib/dahlia/blob/${src.tag}/CHANGELOG.md";
    description = "Simple text formatting package, inspired by the game Minecraft";
    license = lib.licenses.mit;
    homepage = "https://github.com/dahlia-lib/dahlia";
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "dahlia";
  };
}
