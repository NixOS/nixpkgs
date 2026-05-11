{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  attrs,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "attrs-strict";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "attrs-strict";
    tag = finalAttrs.version;
    hash = "sha256-dDOD4Y57E+i8D0S4q+C6t7zjBTsS8q2UFiS22Dsp0Z8=";
  };

  patches = [
    # Upstream PR: https://github.com/bloomberg/attrs-strict/pull/117
    ./fix-tests.patch
  ];

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
    description = "Python package which contains runtime validation for attrs data classes based on the types existing in the typing module";
    homepage = "https://github.com/bloomberg/attrs-strict";
    changelog = "https://github.com/bloomberg/attrs-strict/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
