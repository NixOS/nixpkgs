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
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "asdf-astropy";
    tag = version;
    hash = "sha256-CCLoG3zV34kmdGYN6RLi5u2v0RDvEqVN6VcdrX7L4uY=";
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

  meta = with lib; {
    description = "Extension library for ASDF to provide support for Astropy";
    homepage = "https://github.com/astropy/asdf-astropy";
    changelog = "https://github.com/astropy/asdf-astropy/blob/${src.tag}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
