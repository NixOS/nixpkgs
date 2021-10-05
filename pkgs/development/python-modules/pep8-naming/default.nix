{ lib
, fetchPypi
, buildPythonPackage
, flake8
, flake8-polyfill
, python
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uyRVlHdX0WKqTK1V26TOApAFzRaS8omaIdUdhjDKeEE=";
  };

  propagatedBuildInputs = [
    flake8
    flake8-polyfill
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
