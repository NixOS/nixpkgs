{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, mypy-extensions
, numpy
, pydantic
, pytest-mypy-plugins
, pytestCheckHook
, pythonOlder
, typing-extensions
, wrapt
}:

buildPythonPackage rec {
  pname = "psygnal";
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+VO2OlDzBECkasLBvZWDsqDeooU6CnRFjeI/ISLWAnA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    mypy-extensions
    typing-extensions
  ];

  nativeCheckInputs = [
    numpy
    pydantic
    pytest-mypy-plugins
    pytestCheckHook
    wrapt
  ];

  pythonImportsCheck = [
    "psygnal"
  ];

  meta = with lib; {
    description = "Implementation of Qt Signals";
    homepage = "https://github.com/pyapp-kit/psygnal";
    changelog = "https://github.com/pyapp-kit/psygnal/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
