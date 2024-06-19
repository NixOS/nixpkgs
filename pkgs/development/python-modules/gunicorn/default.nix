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
  version = "22.0.0";
  pyproject = true;

  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    rev = "refs/tags/${version}";
    hash = "sha256-xIXQMAdTZEBORu6789tLpT1OpBL+aveL/MfDj4f4bes=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=gunicorn --cov-report=xml" ""
  '';

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

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  meta = {
    description = "gunicorn 'Green Unicorn' is a WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    homepage = "https://github.com/benoitc/gunicorn";
    changelog = "https://github.com/benoitc/gunicorn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "gunicorn";
  };
}
