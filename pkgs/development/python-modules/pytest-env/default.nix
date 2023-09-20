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
  version = "0.8.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "pytest_env";
    inherit version;
    hash = "sha256-uu2bO2uud711uSOODtHuaQOkKAaunWrv+4dUzVWE1P8=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pytest plugin used to set environment variables";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
