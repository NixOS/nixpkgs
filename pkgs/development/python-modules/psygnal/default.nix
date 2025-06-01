{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  mypy-extensions,
  numpy,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  toolz,
  typing-extensions,
  wrapt,
  attrs,
}:

buildPythonPackage rec {
  pname = "psygnal";
  version = "0.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "psygnal";
    tag = "v${version}";
    hash = "sha256-ZEN8S2sI1usXl5A1Ow1+l4BBB6qNnlVt/nvFtAX4maY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
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

  pytestFlagsArray = [
    "-W"
    "ignore::pydantic.warnings.PydanticDeprecatedSince211"
  ];

  pythonImportsCheck = [ "psygnal" ];

  meta = with lib; {
    description = "Implementation of Qt Signals";
    homepage = "https://github.com/pyapp-kit/psygnal";
    changelog = "https://github.com/pyapp-kit/psygnal/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
