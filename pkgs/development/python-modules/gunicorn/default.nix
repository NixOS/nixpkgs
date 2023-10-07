{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, pythonOlder
, eventlet
, gevent
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "21.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    rev = version;
    hash = "sha256-xP7NNKtz3KNrhcAc00ovLZRx2h6ZqHbwiFOpCiuwf98=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=gunicorn --cov-report=xml" ""
  '';

  propagatedBuildInputs = [
    packaging
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
