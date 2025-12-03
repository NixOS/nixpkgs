{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  requests,
  setuptools-scm,
  setuptools,
  waitress,
}:

buildPythonPackage rec {
  pname = "requests-unixsocket";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "requests_unixsocket";
    inherit version;
    hash = "sha256-sllhWMNW7O5o0nukaaUiESMKxvsM3otmr7GfDtR6GZU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    waitress
  ];

  pythonImportsCheck = [ "requests_unixsocket" ];

  meta = with lib; {
    description = "Use requests to talk HTTP via a UNIX domain socket";
    homepage = "https://github.com/msabramo/requests-unixsocket";
    changelog = "https://github.com/msabramo/requests-unixsocket/releases/tag/v${version}";
    license = licenses.asl20;
  };
}
