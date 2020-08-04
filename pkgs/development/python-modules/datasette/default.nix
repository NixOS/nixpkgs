{ lib
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, click
, click-default-group
, janus
, jinja2
, hupper
, pint
, pluggy
, uvicorn
# Check Inputs
, pytestCheckHook
, pytestrunner
, pytest-asyncio
, black
, aiohttp
, beautifulsoup4
, asgiref
, setuptools
}:

buildPythonPackage rec {
  pname = "datasette";
  version = "0.39";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "datasette";
    rev = version;
    sha256 = "07d46512bc9sdan9lv39sf1bwlf7vf1bfhcsm825vk7sv7g9kczd";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    aiofiles
    click
    click-default-group
    janus
    jinja2
    hupper
    pint
    pluggy
    uvicorn
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    aiohttp
    beautifulsoup4
    black
    asgiref
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "click~=7.1.1" "click" \
      --replace "click-default-group~=1.2.2" "click-default-group" \
      --replace "Jinja2~=2.10.3" "Jinja2" \
      --replace "hupper~=1.9" "hupper" \
      --replace "pint~=0.9" "pint" \
      --replace "pluggy~=0.13.0" "pint" \
      --replace "uvicorn~=0.11" "uvicorn" \
      --replace "aiofiles~=0.4.0" "aiofiles" \
      --replace "janus~=0.4.0" "janus" \
      --replace "PyYAML~=5.3" "PyYAML"
  '';

  # many tests require network access
  # test_black fails on darwin
  dontUseSetuptoolsCheck = true;
  pytestFlagsArray = [
    "--ignore=tests/test_api.py"
    "--ignore=tests/test_csv.py"
    "--ignore=tests/test_html.py"
    "--ignore=tests/test_docs.py"
    "--ignore=tests/test_black.py"
  ];
  disabledTests = [
    "facet"
    "_invalid_database" # checks error message when connecting to invalid database
  ];

  meta = with lib; {
    description = "An instant JSON API for your SQLite databases";
    homepage = "https://github.com/simonw/datasette";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
