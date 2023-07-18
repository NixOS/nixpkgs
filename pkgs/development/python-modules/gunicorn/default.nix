{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, eventlet
, gevent
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "21.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    rev = version;
    hash = "sha256-4NrpGpg1kJy54KT3Ao24ZtcCasYjLtkMbHDdBDYbR44=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=gunicorn --cov-report=xml" ""
  '';

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    eventlet
    gevent
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gunicorn" ];

  meta = with lib; {
    homepage = "https://github.com/benoitc/gunicorn";
    description = "gunicorn 'Green Unicorn' is a WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
