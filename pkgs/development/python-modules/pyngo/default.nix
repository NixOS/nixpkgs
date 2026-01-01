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
  version = "2.4.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "yezz123";
    repo = "pyngo";
    tag = version;
    hash = "sha256-vLQz4qjxOnMUZ/SCR7XSg6yCv5ms0eCpm4Azgi8AeSA=";
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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/yezz123/pyngo/releases/tag/${src.tag}";
    description = "Pydantic model support for Django & Django-Rest-Framework";
    homepage = "https://github.com/yezz123/pyngo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    changelog = "https://github.com/yezz123/pyngo/releases/tag/${src.tag}";
    description = "Pydantic model support for Django & Django-Rest-Framework";
    homepage = "https://github.com/yezz123/pyngo";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
