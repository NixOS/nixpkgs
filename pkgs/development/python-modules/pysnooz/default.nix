{ lib
, bleak
, bleak-retry-connector
, bluetooth-sensor-state-data
, buildPythonPackage
, events
, fetchFromGitHub
, freezegun
, home-assistant-bluetooth
, poetry-core
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, transitions
}:

buildPythonPackage rec {
  pname = "pysnooz";
  version = "0.8.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "AustinBrunkhorst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X7RjI4KytJI9raHAJHLygV3J4zHKuHk8Kq+3JfktPeg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'transitions = "^0.8.11"' 'transitions = ">0.8.11"' \
      --replace " --cov=pysnooz --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    bluetooth-sensor-state-data
    events
    home-assistant-bluetooth
    transitions
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysnooz"
  ];

  meta = with lib; {
    description = "Library to control SNOOZ white noise machines";
    homepage = "https://github.com/AustinBrunkhorst/pysnooz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
