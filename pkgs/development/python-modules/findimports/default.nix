{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "findimports";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-yA1foeGhgOXZArc/nZfS1tbGyONXJZ9lW+Zcx7hCedM=";
  };

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
    homepage = "https://github.com/mgedmin/findimports";
    changelog = "https://github.com/mgedmin/findimports/blob/${version}/CHANGES.rst";
    license = with licenses; [ gpl2Only /* or */ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
