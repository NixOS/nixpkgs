{ lib
, aiohttp-retry
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
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VwcYyD9JtLDU2Bgp2hlptDz3vPoX4revTRKTA8OkWEw=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=pyrainbird --cov-report=term-missing" ""

    substituteInPlace setup.cfg \
      --replace "pycryptodome>=3.16.0" "pycryptodome"
  '';

  propagatedBuildInputs = [
    aiohttp-retry
    ical
    pycryptodome
    pydantic
    python-dateutil
    pyyaml
    requests
  ];

  __darwinAllowLocalNetworking = true;

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
