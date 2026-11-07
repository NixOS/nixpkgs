{
  lib,
  aiomqtt,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  tabulate,
  uv-build,
}:

buildPythonPackage rec {
  pname = "roombapy";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "roombapy";
    tag = version;
    hash = "sha256-7E68w7BDmERCCQjdB79vw60Xy/nAQKH2ym8qzPOAU2I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.5,<0.13.0" "uv_build"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "orjson" ];

  build-system = [
    uv-build
  ];

  dependencies = [
    aiomqtt
    mashumaro
    orjson
  ];

  optional-dependencies.cli = [
    click
    tabulate
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_client.py"
    "tests/test_commands.py"
    "tests/test_discovery.py"
    "tests/test_robustness.py"
    "tests/test_supervisor.py"
    "tests/test_watch.py"
  ];

  disabledTests = [
    # Test want to connect to a local MQTT broker
    "test_roomba_connect"
  ];

  pythonImportsCheck = [ "roombapy" ];

  meta = {
    description = "Python program and library to control Wi-Fi enabled iRobot Roombas";
    mainProgram = "roombapy";
    homepage = "https://github.com/pschmitt/roombapy";
    changelog = "https://github.com/pschmitt/roombapy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
