{ lib
, fetchPypi
, buildPythonPackage
, flake8
, python
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ovd82qnHll98haVs1Xk1RVPJu9P98weKd28S21TdaUQ=";
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
