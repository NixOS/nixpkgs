{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools-scm
, cython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyclipper";
  version = "1.3.0.post3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-viBnmzbCAH9QaVHwUq43rm11e8o3N/jtGsGpmRZokaw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
    cython
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyclipper"
  ];

  meta = with lib; {
    description = "Cython wrapper for clipper library";
    homepage = "https://github.com/fonttools/pyclipper";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
