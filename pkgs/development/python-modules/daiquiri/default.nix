{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-json-logger,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "daiquiri";
  version = "3.2.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xy6G1vyovDjR6a36YFGE32/eo3AuB8oC0Wqj0AQ7Luw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ python-json-logger ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "daiquiri" ];

  meta = with lib; {
    description = "Library to configure Python logging easily";
    homepage = "https://github.com/Mergifyio/daiquiri";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
