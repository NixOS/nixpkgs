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
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andylockran";
    repo = "heatmiserV3";
    tag = version;
    hash = "sha256-crpiSlRSEZBmzsQabEuuJqPpFr/+FTykcZcbSVI2n1M=";
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
