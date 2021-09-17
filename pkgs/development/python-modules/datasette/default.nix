{ lib
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, asgi-csrf
, click
, click-default-group
, itsdangerous
, janus
, jinja2
, hupper
, mergedeep
, pint
, pluggy
, python-baseconv
, pyyaml
, uvicorn
, httpx
# Check Inputs
, pytestCheckHook
, pytest-runner
, pytest-asyncio
, pytest-timeout
, aiohttp
, beautifulsoup4
, asgiref
, setuptools
, trustme
, pythonOlder
}:

buildPythonPackage rec {
  pname = "datasette";
  version = "0.58.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "sha256-dtKqp7LV1fRjwOMAlmmAnC19j8hLA1oixGextATW6z0=";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [
    aiofiles
    asgi-csrf
    asgiref
    click
    click-default-group
    httpx
    hupper
    itsdangerous
    janus
    jinja2
    mergedeep
    pint
    pluggy
    python-baseconv
    pyyaml
    setuptools
    uvicorn
  ];

  checkInputs = [
    aiohttp
    beautifulsoup4
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
    trustme
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "click-default-group~=1.2.2" "click-default-group" \
      --replace "hupper~=1.9" "hupper" \
      --replace "pint~=0.9" "pint" \
      --replace "pluggy~=0.13.0" "pluggy" \
      --replace "uvicorn~=0.11" "uvicorn" \
      --replace "PyYAML~=5.3" "PyYAML"
  '';

  # takes 30-180 mins to run entire test suite, not worth the CPU resources, slows down reviews
  # with pytest-xdist, it still takes around 10 mins with 32 cores
  # just run the csv tests, as this should give some indictation of correctness
  pytestFlagsArray = [
    "tests/test_csv.py"
  ];

  disabledTests = [
    "facet"
    "_invalid_database" # checks error message when connecting to invalid database
  ];

  pythonImportsCheck = [
    "datasette"
    "datasette.cli"
    "datasette.app"
    "datasette.database"
    "datasette.renderer"
    "datasette.tracer"
    "datasette.plugins"
  ];

  meta = with lib; {
    description = "Multi-tool for exploring and publishing data";
    homepage = "https://datasette.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
