{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "attrs-strict";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "attrs_strict";
    hash = "sha256-5wSGNiAUbF8qi2Ac1FdNFIkT2yb8Bjb5Qf5CEuQl6v4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
  ];

  pythonImportsCheck = [ "attrs_strict" ];

  # No tests in the pypi archive
  doCheck = false;

  meta = {
    changelog = "https://github.com/bloomberg/attrs-strict/releases/tag/${version}";
    description = "Python package which contains runtime validation for attrs data classes based on the types existing in the typing module";
    homepage = "https://github.com/bloomberg/attrs-strict";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
