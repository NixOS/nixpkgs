{ lib
<<<<<<< HEAD
, aiohttp-retry
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, fetchFromGitHub
, freezegun
, ical
, parameterized
, pycryptodome
, pydantic
, pytest-aiohttp
, pytest-asyncio
, pytest-golden
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, pyyaml
, requests
, requests-mock
, responses
}:

buildPythonPackage rec {
  pname = "pyrainbird";
<<<<<<< HEAD
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.10";
=======
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-VwcYyD9JtLDU2Bgp2hlptDz3vPoX4revTRKTA8OkWEw=";
=======
    hash = "sha256-ssm/nFciUeWexgsKUpF4qZHz/grG8OYJV7roBAjMsac=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=pyrainbird --cov-report=term-missing" ""

    substituteInPlace setup.cfg \
      --replace "pycryptodome>=3.16.0" "pycryptodome"
  '';

  propagatedBuildInputs = [
<<<<<<< HEAD
    aiohttp-retry
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ical
    pycryptodome
    pydantic
    python-dateutil
    pyyaml
    requests
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    freezegun
    parameterized
    pytest-aiohttp
    pytest-asyncio
    pytest-golden
    pytest-mock
    pytestCheckHook
    requests-mock
    responses
  ];

  pythonImportsCheck = [
    "pyrainbird"
  ];

  meta = with lib; {
    description = "Module to interact with Rainbird controllers";
    homepage = "https://github.com/allenporter/pyrainbird";
    changelog = "https://github.com/allenporter/pyrainbird/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
