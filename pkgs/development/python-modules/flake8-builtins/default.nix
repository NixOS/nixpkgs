{ lib
, buildPythonPackage
, fetchFromGitHub
, flake8
, hatchling
, pytest
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "flake8-builtins";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gforcada";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0xDUwMqhuLQ6HVSbY2TnPn479V/8K8xFjQCaQQ51Cgs=";
  };

  nativeBuildInputs = [
    hatchling
    setuptools
  ];

  propagatedBuildInputs = [
    flake8
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    pytest run_tests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Check for python builtins being used as variables or parameters";
    homepage = "https://github.com/gforcada/flake8-builtins";
    changelog = "https://github.com/gforcada/flake8-builtins/blob/${version}/HISTORY.rst";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dyniec ];
  };
}
