{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, click-default-group
, sanic
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
}:

buildPythonPackage rec {
  pname = "datasette";
  version = "0.28";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "datasette";
    rev = version;
    sha256 = "1m2s03gyq0ghjc3s0b5snpinisddywpgii2f0zqa3v4ljmzanx7h";
  };

  buildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    click
    click-default-group
    sanic
    jinja2
    hupper
    pint
    pluggy
  ];

  checkInputs = [
    pytest
    pytest-asyncio
    aiohttp
    beautifulsoup4
    black
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "click-default-group==1.2" "click-default-group" \
      --replace "Sanic==0.7.0" "Sanic" \
      --replace "hupper==1.0" "hupper" \
      --replace "pint==0.8.1" "pint" \
      --replace "Jinja2==2.10.1" "Jinja2"
  '';

  # many tests require network access
  checkPhase = ''
    pytest --ignore tests/test_api.py \
           --ignore tests/test_csv.py \
           --ignore tests/test_html.py
  '';

  meta = with lib; {
    description = "An instant JSON API for your SQLite databases";
    homepage = https://github.com/simonw/datasette;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };

}
