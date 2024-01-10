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
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yezz123";
    repo = "pyngo";
    rev = "refs/tags/${version}";
    hash = "sha256-cMWYmCbkhJmz+RMCh3NIhOkC5bX46nwz09WhTV+Mz6w=";
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
