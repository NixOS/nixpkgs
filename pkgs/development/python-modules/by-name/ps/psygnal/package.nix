{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  mypy-extensions,
  numpy,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  toolz,
  typing-extensions,
  wrapt,
  attrs,
}:

buildPythonPackage rec {
  pname = "psygnal";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "psygnal";
    tag = "v${version}";
    hash = "sha256-RQ53elonwvna5UDVell3JI1dcZSMHREyB51r+ddsW2M=";
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
    pytest-asyncio
    pytestCheckHook
    toolz
    wrapt
    attrs
  ];

  pytestFlags = [
    "-Wignore::pydantic.warnings.PydanticDeprecatedSince211"
  ];

  pythonImportsCheck = [ "psygnal" ];

  meta = {
    description = "Implementation of Qt Signals";
    homepage = "https://github.com/pyapp-kit/psygnal";
    changelog = "https://github.com/pyapp-kit/psygnal/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
