{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  django,
  pydantic,
  typing-extensions,

  # tests
  django-stubs,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyngo";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "yezz123";
    repo = "pyngo";
    rev = "refs/tags/${version}";
    hash = "sha256-E3UNgn/L1bbfYljufPp+bGAvSsADpPAvv/eJimD8v50=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonRelaxDeps = [
    "pydantic"
    "typing-extensions"
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
