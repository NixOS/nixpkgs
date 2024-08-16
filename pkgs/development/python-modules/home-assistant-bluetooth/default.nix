{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cython,
  poetry-core,
  setuptools,

  # dependencies
  habluetooth,

  # tests
  bleak,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "home-assistant-bluetooth";
  version = "1.12.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "home-assistant-bluetooth";
    rev = "refs/tags/v${version}";
    hash = "sha256-WAsgiOmYqmt/PCKp+vZA2To95YZAgnYCF8ysCn5N9nc=";
  };

  postPatch = ''
    # drop pytest parametrization (coverage, etc.)
    sed -i '/addopts/d' pyproject.toml
  '';

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ habluetooth ];

  nativeCheckInputs = [
    bleak
    pytestCheckHook
  ];

  pythonImportsCheck = [ "home_assistant_bluetooth" ];

  meta = with lib; {
    description = "Basic bluetooth models used by Home Assistant";
    changelog = "https://github.com/home-assistant-libs/home-assistant-bluetooth/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/home-assistant-libs/home-assistant-bluetooth";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
