{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "aigyminsper";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QIT6qeSfLOLNhn5CFIlKaKn/gvZDwcvFxJFvBTCwQ4g=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "aigyminsper"
  ];

  meta = {
    description = "Insper's college Artificial Intelligence library for learning";
    homepage = "https://pypi.org/project/aigyminsper/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
