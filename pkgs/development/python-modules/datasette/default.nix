{ lib
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, asgi-csrf
, click
, click-default-group
, janus
, jinja2
, hupper
, mergedeep
, pint
, pluggy
, python-baseconv
, pyyaml
, uvicorn
# Check Inputs
, pytestCheckHook
, pytestrunner
, pytest-asyncio
, aiohttp
, beautifulsoup4
, asgiref
, setuptools
}:

buildPythonPackage rec {
  pname = "datasette";
  version = "0.46";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "datasette";
    rev = version;
    sha256 = "0g4dfq5ykifa9628cb4i7gvx98p8hvb99gzfxk3bkvq1v9p4kcqq";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    aiofiles
    asgi-csrf
    click
    click-default-group
    janus
    jinja2
    hupper
    mergedeep
    pint
    pluggy
    python-baseconv
    pyyaml
    uvicorn
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    aiohttp
    beautifulsoup4
    asgiref
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "click~=7.1.1" "click" \
      --replace "click-default-group~=1.2.2" "click-default-group" \
      --replace "hupper~=1.9" "hupper" \
      --replace "pint~=0.9" "pint" \
      --replace "pluggy~=0.13.0" "pluggy" \
      --replace "uvicorn~=0.11" "uvicorn" \
      --replace "PyYAML~=5.3" "PyYAML"
  '';

  # takes 30-180 mins to run entire test suite, not worth the cpu resources, slows down reviews
  # with pytest-xdist, it still takes around 10mins with 32 cores
  # just run the messages tests, as this should give some indictation of correctness
  pytestFlagsArray = [
    "tests/test_messages.py"
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
    description = "An instant JSON API for your SQLite databases";
    homepage = "https://github.com/simonw/datasette";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
