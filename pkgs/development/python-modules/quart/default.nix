{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, click
, aiofiles
, werkzeug
, jinja2
, hypercorn
, itsdangerous
, blinker
, hypothesis
, pytestCheckHook
, pytest-asyncio
, poetry-core
}:

buildPythonPackage rec {
  pname = "quart";
  version = "0.18.0";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = pname;
    rev = version;
    sha256 = "sha256-xpMvCOFoSpuit+KnLs3iWwneK++mLgjD7E6vTUUMwaU=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
        --replace "--no-cov-on-fail" ""
  '';

  propagatedBuildInputs = [ click aiofiles jinja2 hypercorn ];

  checkInputs = [
    pytestCheckHook
    poetry-core
    blinker
    werkzeug
    hypothesis
    itsdangerous
    pytest-asyncio
  ];

  pythonImportsCheck = [ "quart" ];

  meta = with lib; {
    homepage = "https://quart.palletsprojects.com/en/latest/";
    description =
      "ASGI web microframework, built as an asyncio alternative to Flask";
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
  };
}
