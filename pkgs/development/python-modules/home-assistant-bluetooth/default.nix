{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,
  setuptools,

  # dependencies
  habluetooth,

  # tests
  bleak,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "home-assistant-bluetooth";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "home-assistant-bluetooth";
    tag = "v${version}";
    hash = "sha256-A29Jezj9kQ/v4irvpcpCiZlrNQBQwByrSJOx4HaXTdc=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [ habluetooth ];

  doCheck = false; # broken with habluetooth>=4.0

  nativeCheckInputs = [
    bleak
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "home_assistant_bluetooth" ];

  meta = {
    description = "Basic bluetooth models used by Home Assistant";
    changelog = "https://github.com/home-assistant-libs/home-assistant-bluetooth/blob/${src.tag}/CHANGELOG.md";
    homepage = "https://github.com/home-assistant-libs/home-assistant-bluetooth";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
}
