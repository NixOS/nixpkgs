{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, pytest
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-snapshot";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "joseph-roitman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xnfsB4wmsvqq5FfhLasSpxZh7+vhQsND6+Lxu0OuCvs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_snapshot"
  ];

  meta = with lib; {
    description = "A plugin to enable snapshot testing with pytest";
    homepage = "https://github.com/joseph-roitman/pytest-snapshot/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
