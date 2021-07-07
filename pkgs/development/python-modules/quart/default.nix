{ lib
, buildPythonPackage
, fetchFromGitLab
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
, pytest-sugar
}:

buildPythonPackage rec {
  pname = "quart";
  version = "0.15.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "pgjones";
    repo = pname;
    rev = version;
    sha256 = "036ip3lwpf4wkssmfpsdxnw46ncpafzwfswvsvkngbm9gnf1v4r7";
  };

  patches = [ ./no-coverage.patch ];

  propagatedBuildInputs = [
    click
    aiofiles
    jinja2
    hypercorn
    itsdangerous
    blinker
    werkzeug
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
    pytest-asyncio
    pytest-sugar
  ];

  pythonImportsCheck = [ "quart" ];

  meta = with lib; {
    homepage = "https://pgjones.gitlab.io/quart/";
    description = "Python ASGI web microframework";
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
  };
}
