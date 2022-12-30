{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-env";
  version = "0.8.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "pytest_env";
    inherit version;
    hash = "sha256-17L1Jz7G0eIhdXmYvC9Q0kdO19C5MxuSVWAR+txOmr8=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pytest plugin used to set environment variables";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
