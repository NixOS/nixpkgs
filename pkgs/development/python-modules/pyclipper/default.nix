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
  version = "1.3.0.post6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "pyclipper";
    tag = version;
    hash = "sha256-s2D0ipDatAaF7A1RYOKyI31nkfc/WL3vHWsAMbo+WcY=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyclipper" ];

  meta = with lib; {
    description = "Cython wrapper for clipper library";
    homepage = "https://github.com/fonttools/pyclipper";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
