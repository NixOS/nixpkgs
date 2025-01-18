{
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-resources,
  lib,
  poetry-core,
  pyserial,
  pyserial-asyncio,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "heatmiserv3";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andylockran";
    repo = "heatmiserV3";
    tag = version;
    hash = "sha256-Ia0QUMDvuvn2af52lW7ObSQ9MSPNOgWyBuFBnqfYrpM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    appdirs
    importlib-resources
    pyserial
    pyserial-asyncio
    pyyaml
  ];

  pythonImportsCheck = [ "heatmiserv3" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Library to interact with Heatmiser Themostats using V3 protocol";
    homepage = "https://github.com/andylockran/heatmiserV3";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
