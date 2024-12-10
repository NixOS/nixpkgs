{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiofiles,
  asgi-csrf,
  click,
  click-default-group,
  flexcache,
  flexparser,
  httpx,
  hupper,
  itsdangerous,
  janus,
  jinja2,
  mergedeep,
  platformdirs,
  pluggy,
  pyyaml,
  typing-extensions,
  uvicorn,
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,
  aiohttp,
  beautifulsoup4,
  asgiref,
  setuptools,
  trustme,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "datasette";
  version = "0.65.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kVtldBuDy19DmyxEQLtAjs1qiNIjaT8+rnHlFfGNHec=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "pip"
    "setuptools"
  ];

  dependencies = [
    aiofiles
    asgi-csrf
    asgiref
    click
    click-default-group
    flexcache
    flexparser
    httpx
    hupper
    itsdangerous
    janus
    jinja2
    mergedeep
    platformdirs
    pluggy
    pyyaml
    typing-extensions
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
    # datasette/app.py:14: DeprecationWarning: pkg_resources is deprecated as an API. See https://setuptools.pypa.io/en/latest/pkg_resources.html
    "-W"
    "ignore::DeprecationWarning"
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
    mainProgram = "datasette";
    homepage = "https://datasette.io/";
    changelog = "https://github.com/simonw/datasette/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
