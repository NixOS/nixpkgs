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
  version = "1.13.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "home-assistant-bluetooth";
    tag = "v${version}";
    hash = "sha256-piX812Uzd2F8A8+IF/17N+xy6ENpfRVJ1BxsAxL5aj0=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [ habluetooth ];

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
    maintainers = lib.teams.home-assistant.members;
  };
}
