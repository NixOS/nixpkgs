{
  lib,
  bleak,
  bleak-retry-connector,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  events,
  fetchFromGitHub,
  freezegun,
  home-assistant-bluetooth,
  poetry-core,
  pytest-asyncio_0,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  transitions,
}:

buildPythonPackage rec {
  pname = "pysnooz";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AustinBrunkhorst";
    repo = "pysnooz";
    tag = "v${version}";
    hash = "sha256-sJ2/miVwRH2ggnFi3tLp3trrNJNIiKx66fYJKyuWMx4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'transitions = "^0.8.11"' 'transitions = ">=0.8.11"' \
      --replace-fail 'Events = "^0.4"' 'Events = ">=0.4"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    bleak-retry-connector
    bluetooth-sensor-state-data
    events
    home-assistant-bluetooth
    transitions
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio_0
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysnooz" ];

  meta = {
    description = "Library to control SNOOZ white noise machines";
    homepage = "https://github.com/AustinBrunkhorst/pysnooz";
    changelog = "https://github.com/AustinBrunkhorst/pysnooz/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
