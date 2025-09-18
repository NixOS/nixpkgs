{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flake8,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.15.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pep8-naming";
    tag = version;
    hash = "sha256-swSaMOrgd6R4i92LodJVsquls9wp5ZFyzK0LNqwODoc=";
  };

  build-system = [ setuptools ];

  dependencies = [ flake8 ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "pep8ext_naming" ];

  meta = with lib; {
    description = "Check PEP-8 naming conventions, plugin for flake8";
    homepage = "https://github.com/PyCQA/pep8-naming";
    changelog = "https://github.com/PyCQA/pep8-naming/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
