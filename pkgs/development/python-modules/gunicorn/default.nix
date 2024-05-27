{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  packaging,

  # optional-dependencies
  eventlet,
  gevent,
  tornado,
  setproctitle,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "21.2.0";
  pyproject = true;

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

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ packaging ];

  passthru.optional-dependencies = {
    gevent = [ gevent ];
    eventlet = [ eventlet ];
    tornado = [ tornado ];
    gthread = [ ];
    setproctitle = [ setproctitle ];
  };

  pythonImportsCheck = [ "gunicorn" ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/benoitc/gunicorn/releases/tag/${version}";
    homepage = "https://github.com/benoitc/gunicorn";
    description = "gunicorn 'Green Unicorn' is a WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "gunicorn";
  };
}
