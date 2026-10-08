{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
  pytest-codspeed,
  pytest-snapshot,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "25.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "awesomeversion";
    tag = version;
    hash = "sha256-2CEuJagUkYwtjzpQLYLlz+V5e2feEU6di3wI0+uWuy4=";
  };

  nativeBuildInputs = [
    # Upstream doesn't set a version
    pyprojectVersionPatchHook
  ];

  build-system = [ hatchling ];

  pythonImportsCheck = [ "awesomeversion" ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-snapshot
    pytestCheckHook
  ];

  meta = {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    changelog = "https://github.com/ludeeus/awesomeversion/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
