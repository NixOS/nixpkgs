{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  attrs,
  setuptools,
  setuptools-scm
}:

buildPythonPackage rec {
  pname = "attrs-strict";
  version = "1.0.1";
  disabled = pythonOlder "3.7";
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

  meta = {
    description = "Python package which contains runtime validation for attrs data classes based on the types existing in the typing module";
    homepage = "https://github.com/bloomberg/attrs-strict";
    changelog = "https://github.com/bloomberg/attrs-strict/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
