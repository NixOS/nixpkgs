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
, pytestCheckHook
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
  version = "0.64.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-hUMaveScSGbiELvN2oo8Nf/jFvYXeLpxTONl1R4UOZU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' "" \
      --replace "click-default-group-wheel>=1.2.2" "click-default-group"
  '';

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

  nativeCheckInputs = [
    aiohttp
    beautifulsoup4
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
    trustme
  ];

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
    maintainers = with maintainers; [ costrouc ];
  };
}
