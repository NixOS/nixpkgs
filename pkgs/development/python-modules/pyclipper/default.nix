{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  cython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyclipper";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "pyclipper";
    tag = version;
    hash = "sha256-mh+F3iFCItmLbV6bF7Mi5IaWwjcKrE9Nk6lxglyFUg4=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyclipper" ];

  meta = {
    description = "Cython wrapper for clipper library";
    homepage = "https://github.com/fonttools/pyclipper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthuszagh ];
  };
}
