{
  buildPythonPackage,
  fetchPypi,
  lib,
  hatch-requirements-txt,
  natsort,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "domdf-python-tools";
  version = "3.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "domdf_python_tools";
    hash = "sha256-UYrEeyenmacrATd/IViOQVUKWZGMJadPtV/H0V+7JDQ=";
  };

  build-system = [ hatch-requirements-txt ];

  dependencies = [
    natsort
    typing-extensions
  ];

  meta = {
    description = "Helpful functions for Python";
    homepage = "https://github.com/domdfcoding/domdf_python_tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
