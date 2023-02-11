{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, eventlet
, gevent
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "20.1.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    rev = version;
    sha256 = "sha256-xdNHm8NQWlAlflxof4cz37EoM74xbWrNaf6jlwwzHv4=";
  };

  patches = [
    (fetchpatch {
      # fix eventlet 0.30.3+ compability
      url = "https://github.com/benoitc/gunicorn/commit/6a8ebb4844b2f28596ffe7421eb9f7d08c8dc4d8.patch";
      sha256 = "sha256-+iApgohzPZ/cHTGBNb7XkqLaHOVVPF26BnPUsvISoZw=";
    })
  ];

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
