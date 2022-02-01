{ lib
, buildPythonPackage
, fetchFromGitLab
, poetry
, itsdangerous
, aiofiles
, blinker
, click
, hypercorn
, jinja2
, toml
, werkzeug
, hypothesis
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "quart";
  version = "0.16.2";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "pgjones";
    repo = pname;
    rev = version;
    sha256 = "1zdlcm9jnpaj4fqjir45rrjc362nfrphiy7arpz844l7h6pjh1mw";
  };

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    itsdangerous
    aiofiles
    blinker
    click
    hypercorn
    jinja2
    toml
    werkzeug
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--no-cov-on-fail" ""
  '';

  checkInputs = [
    hypothesis
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "quart" ];

  meta = with lib; {
    description = "Quart is a Python ASGI web microframework with the same API as Flask";
    homepage = "https://gitlab.com/pgjones/quart";
    license = licenses.mit;
    maintainers = with maintainers; [ ozkutuk ];
  };
}
