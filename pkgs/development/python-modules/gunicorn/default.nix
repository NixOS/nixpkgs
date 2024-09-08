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
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "23.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    rev = "refs/tags/${version}";
    hash = "sha256-Dq/mrQwo3II6DBvYfD1FHsKHaIlyHlJCZ+ZyrM4Efe0=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  optional-dependencies = {
    gevent = [ gevent ];
    eventlet = [ eventlet ];
    tornado = [ tornado ];
    gthread = [ ];
    setproctitle = [ setproctitle ];
  };

  pythonImportsCheck = [ "gunicorn" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  meta = {
    description = "gunicorn 'Green Unicorn' is a WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    homepage = "https://github.com/benoitc/gunicorn";
    changelog = "https://github.com/benoitc/gunicorn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "gunicorn";
  };
}
