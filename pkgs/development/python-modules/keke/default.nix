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
  version = "0.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qGU7fZk23a4I0eosKY5eNqUOs3lwXj90qwix9q44MaA=";
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
