{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, click-default-group
, jinja2
, hupper
, pint
, pluggy
, pytest
, pytestrunner
, pytest-asyncio
, black
, aiohttp
, beautifulsoup4
, uvicorn
, asgiref
, aiofiles
}:

buildPythonPackage rec {
  pname = "datasette";
  version = "0.35";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "datasette";
    rev = version;
    sha256 = "0v6af7agg27lapz1nbab07595v4hl2x5wm2f03drj81f7pm8y7hc";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    click
    click-default-group
    jinja2
    hupper
    pint
    pluggy
    uvicorn
    aiofiles
  ];

  checkInputs = [
    pytest
    pytest-asyncio
    aiohttp
    beautifulsoup4
    black
    asgiref
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "click-default-group==1.2" "click-default-group" \
      --replace "Sanic==0.7.0" "Sanic" \
      --replace "hupper==1.0" "hupper" \
      --replace "pint~=0.8.1" "pint" \
      --replace "pluggy~=0.12.0" "pint" \
      --replace "Jinja2==2.10.1" "Jinja2" \
      --replace "uvicorn~=0.8.4" "uvicorn"
  '';

  # many tests require network access
  # test_black fails on darwin
  checkPhase = ''
    pytest --ignore tests/test_api.py \
           --ignore tests/test_csv.py \
           --ignore tests/test_html.py \
           --ignore tests/test_black.py \
           -k 'not facet'
  '';

  meta = with lib; {
    description = "An instant JSON API for your SQLite databases";
    homepage = https://github.com/simonw/datasette;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
