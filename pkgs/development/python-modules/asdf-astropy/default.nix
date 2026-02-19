{
  lib,
  asdf-coordinates-schemas,
  asdf-standard,
  asdf-transform-schemas,
  asdf,
  astropy,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  pytest-astropy-header,
  pytest-doctestplus,
  pytestCheckHook,
  scipy,
  setuptools-scm,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "asdf-astropy";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "asdf-astropy";
    tag = version;
    hash = "sha256-8atPmtVWb+4Dj1Lf0UIusBtAIW7lF5D+1ay7G7Ay3PA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf
    asdf-coordinates-schemas
    asdf-standard
    asdf-transform-schemas
    astropy
    numpy
    packaging
  ];

  nativeCheckInputs = [
    pytest-astropy-header
    pytest-doctestplus
    pytestCheckHook
    scipy
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "asdf_astropy" ];

  meta = {
    description = "Extension library for ASDF to provide support for Astropy";
    homepage = "https://github.com/astropy/asdf-astropy";
    changelog = "https://github.com/astropy/asdf-astropy/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
