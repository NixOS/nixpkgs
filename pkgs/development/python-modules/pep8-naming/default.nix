{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flake8,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-uIVk8+5rVEIBZLz70WUi0O6/Q9ERptJ3b7314gLPeHk=";
  };

  propagatedBuildInputs = [ flake8 ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "pep8ext_naming" ];

  meta = with lib; {
    description = "Check PEP-8 naming conventions, plugin for flake8";
    homepage = "https://github.com/PyCQA/pep8-naming";
    changelog = "https://github.com/PyCQA/pep8-naming/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
