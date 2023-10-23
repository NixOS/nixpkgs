{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, mypy-extensions
, numpy
, pydantic
, pytestCheckHook
, pythonOlder
, toolz
, typing-extensions
, wrapt
}:

buildPythonPackage rec {
  pname = "psygnal";
  version = "0.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Ki2s057aqaZa+kOpAlhBYFpZeuDX42+txQXFuBtXd04=";
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
    pytestCheckHook
    toolz
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
