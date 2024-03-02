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
, attrs
}:

buildPythonPackage rec {
  pname = "psygnal";
  version = "0.9.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-eDfGWmTKJrkkzRy1I3wl3WYPCxtPHSRzqAoOiO7QQ9Y=";
  };

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
    attrs
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
