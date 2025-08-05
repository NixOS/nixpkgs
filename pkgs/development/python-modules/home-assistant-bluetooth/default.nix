{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "fix-tests-with-habluetooth-3.42.0.patch";
      url = "https://github.com/home-assistant-libs/home-assistant-bluetooth/commit/515516bf9b2577c5d4af25cd2f052023ccb8b108.patch";
      includes = [ "tests/test_models.py" ];
      hash = "sha256-9t8VRKQSDxSYiy7bFII62B4O5w5Hx9AbRgvzcT6z1BQ=";
    })
  ];

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
    teams = [ lib.teams.home-assistant ];
  };
}
