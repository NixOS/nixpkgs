{ lib
, bleak
, bleak-retry-connector
, bluetooth-sensor-state-data
, buildPythonPackage
, events
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.8.6";
=======
  version = "0.8.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "AustinBrunkhorst";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-hJwIObiuFEAVhgZXYB9VCeAlewBBnk0oMkP83MUCpyU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'transitions = "^0.8.11"' 'transitions = ">=0.8.11"' \
      --replace 'Events = "^0.4"' 'Events = ">=0.4"' \
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/AustinBrunkhorst/pysnooz/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
