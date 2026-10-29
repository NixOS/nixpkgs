{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pbr,
  setuptools,

  # dependencies
  inflection,
  tinycss2,

  # checks
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "qstylizer";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blambright";
    repo = "qstylizer";
    tag = finalAttrs.version;
    hash = "sha256-Is/kYkSX9fOX+pLv5g1ns2OxeLpSkaCfO2jPIbiuIxA=";
  };

  env.PBR_VERSION = finalAttrs.version;

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    inflection
    tinycss2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "qstylizer" ];

  meta = {
    description = "Qt stylesheet generation utility for PyQt/PySide";
    homepage = "https://github.com/blambright/qstylizer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
