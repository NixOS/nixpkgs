{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook

# build-system
, hatchling

# dependencies
, django
, pydantic
, typing-extensions

# tests
, django-stubs
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pyngo";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "yezz123";
    repo = "pyngo";
    rev = "refs/tags/${version}";
    hash = "sha256-jHPZjS/J1VLpsLN2wg5UJCgavoSEs4Uogo4GI6bZMuY=";
  };

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  propagatedBuildInputs = [
    django
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [ "pyngo" ];

  nativeCheckInputs = [
    django-stubs
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    changelog = "https://github.com/yezz123/pyngo/releases/tag/${version}";
    description = "Pydantic model support for Django & Django-Rest-Framework";
    homepage = "https://github.com/yezz123/pyngo";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
