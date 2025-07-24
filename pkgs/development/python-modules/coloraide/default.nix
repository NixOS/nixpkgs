{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  typing-extensions,
}:
let
  pname = "coloraide";
  version = "4.7.2";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fomOKtF3hzgJvR9f2x2QYYrYdASf6tlS/0Rw0VdmbUs=";
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
