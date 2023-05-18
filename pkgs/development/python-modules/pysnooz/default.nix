{ lib
, bleak
, bleak-retry-connector
, bluetooth-sensor-state-data
, buildPythonPackage
, events
, fetchFromGitHub
, fetchpatch
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
  version = "0.8.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "AustinBrunkhorst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K99sE9vxJo6grkp04DmTKOVqdfpQI0kUzJjSR6gnSew=";
  };

  patches = [
    (fetchpatch {
      # fix tests against bleak 0.20.0+
      # https://github.com/AustinBrunkhorst/pysnooz/pull/9
      name = "pysnooz-bleak-0.20.0-compat.patch";
      url = "https://github.com/AustinBrunkhorst/pysnooz/commit/594951051ceb40003975e61d64cfc683188d87d3.patch";
      hash = "sha256-cWQt9V9IOB0YoW5zUR0PBTqS0a30fMTHpXH6CxWKRcc=";
    })
  ];

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
