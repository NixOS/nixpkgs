{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "findimports";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = "findimports";
    rev = "refs/tags/${version}";
    hash = "sha256-ar05DYSc/raYC1RJyLCxDYnd7Zjx20aczywlb6wc67Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "findimports"
  ];

  checkPhase = ''
    # Tests fails
    rm tests/cmdline.txt

    runHook preCheck
    ${python.interpreter} testsuite.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Module for the analysis of Python import statements";
    mainProgram = "findimports";
    homepage = "https://github.com/mgedmin/findimports";
    changelog = "https://github.com/mgedmin/findimports/blob/${version}/CHANGES.rst";
    license = with licenses; [ gpl2Only /* or */ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
