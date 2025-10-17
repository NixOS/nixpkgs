{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  typing-extensions,
}:
let
  pname = "coloraide";
  version = "5.1";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DfBmpjbb2EgZgfrEkCQNPtkGtANDx8AXErPfVC8rJ1A=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "coloraide"
  ];

  meta = {
    description = "Color library for Python";
    homepage = "https://pypi.org/project/coloraide/";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
  };
}
