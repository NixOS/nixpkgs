{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "attrs-strict";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "attrs-strict";
    tag = version;
    hash = "sha256-dDOD4Y57E+i8D0S4q+C6t7zjBTsS8q2UFiS22Dsp0Z8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
  ];

  pythonImportsCheck = [ "attrs_strict" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/bloomberg/attrs-strict/releases/tag/${version}";
    description = "Python package which contains runtime validation for attrs data classes based on the types existing in the typing module";
    homepage = "https://github.com/bloomberg/attrs-strict";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
