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
  pythonOlder,
  transitions,
}:

buildPythonPackage rec {
  pname = "pysnooz";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "AustinBrunkhorst";
    repo = "pysnooz";
    tag = "v${version}";
    hash = "sha256-jOXmaJprU35sdNRrBBx/YUyiDyyaE1qodWksXkTSEe0=";
  };

  patches = [
    # https://github.com/AustinBrunkhorst/pysnooz/pull/20
    ./bleak-compat.patch
  ];

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

  meta = with lib; {
    description = "Library to control SNOOZ white noise machines";
    homepage = "https://github.com/AustinBrunkhorst/pysnooz";
    changelog = "https://github.com/AustinBrunkhorst/pysnooz/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
