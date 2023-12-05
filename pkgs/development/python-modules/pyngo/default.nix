{ lib
, buildPythonPackage
, fetchFromGitHub

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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yezz123";
    repo = "pyngo";
    rev = version;
    hash = "sha256-qOY1ILMDqSguLnbhuu5JJVMvG3uA08Lv2fB70TgrKqI=";
  };

  nativeBuildInputs = [
    hatchling
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
