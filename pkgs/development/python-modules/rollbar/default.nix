{
  lib,
  aiocontextvars,
  blinker,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  httpx,
  mock,
  pytestCheckHook,
  requests,
  six,
  webob,
}:

buildPythonPackage rec {
  pname = "rollbar";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mK1/kAEseR0LQOrFG2/miLHK3MSq3/dy/Aoj7+dftfw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    six
  ];

  nativeCheckInputs = [
    webob
    blinker
    mock
    httpx
    aiocontextvars
    pytestCheckHook
  ];

  # Still supporting unittest2
  # https://github.com/rollbar/pyrollbar/pull/346
  # https://github.com/rollbar/pyrollbar/pull/340
  doCheck = false;

  pythonImportsCheck = [ "rollbar" ];

  meta = {
    description = "Error tracking and logging from Python to Rollbar";
    mainProgram = "rollbar";
    homepage = "https://github.com/rollbar/pyrollbar";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
