{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flake8
, python
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "sha256-Pr8c4E2momUKv+mwwX4rLZoSJb7H8HAZUaszPR2HK9c=";
  };

  propagatedBuildInputs = [
    flake8
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "pep8ext_naming"
  ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pep8-naming";
    description = "Check PEP-8 naming conventions, plugin for flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
