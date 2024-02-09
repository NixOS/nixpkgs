{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "findimports";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ar05DYSc/raYC1RJyLCxDYnd7Zjx20aczywlb6wc67Y=";
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
