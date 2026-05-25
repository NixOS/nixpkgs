{
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  importlib-resources,
  lib,
  pyserial,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "heatmiserv3";
  version = "2.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andylockran";
    repo = "heatmiserV3";
    tag = version;
    hash = "sha256-mwzW52g3Uz7zxL9R5zePDyxMSramEiaiVm6VPlNyNts=";
  };

  build-system = [ hatchling ];

  pythonRemoveDeps = [
    # https://github.com/andylockran/heatmiserV3/pull/113
    "pytest"
    "pytest-cov"
  ];

  dependencies = [
    appdirs
    importlib-resources
    pyserial
    pyyaml
  ];

  pythonImportsCheck = [ "heatmiserv3" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library to interact with Heatmiser Themostats using V3 protocol";
    homepage = "https://github.com/andylockran/heatmiserV3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
