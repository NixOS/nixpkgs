{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "keke";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H0U6DgZOHKtkPnF/xSNqBGPnD4BViP0JBKpehKKTTzs=";
  };

  installCheckPhase = ''
    python -m keke.tests
  '';

  nativeBuildInputs = [ setuptools-scm ];

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "keke"
  ];

  meta = {
    description = "Easy profiling in chrome trace format";
    homepage = "https://pypi.org/project/keke/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
}
