{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  cryptography,
  transitions,
}:

buildPythonPackage (finalAttrs: {
  pname = "dissononce";
  version = "0.34.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "dissononce";
    tag = finalAttrs.version;
    hash = "sha256-etXxDFPwERDo/YCoGrz4YopwOe9eZqN+vbY0kB0mxkI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    transitions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "dissononce" ];

  meta = {
    homepage = "https://pypi.org/project/dissononce/";
    license = lib.licenses.mit;
    description = "Python implementation for Noise Protocol Framework";
  };
})
