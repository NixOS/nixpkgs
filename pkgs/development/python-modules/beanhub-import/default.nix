{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  beancount-black,
  beancount-parser,
  beanhub-extract,
  hatchling,
  jinja2,
  pydantic,
  pytz,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "beanhub-import";
<<<<<<< HEAD
  version = "1.2.1";
  pyproject = true;

=======
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-import";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-zKlw8KEVc0FJrxWHOx95UXGzqxFFCaYBKID4hRbTQas=";
=======
    hash = "sha256-oExJ8BWJmJkJMGGIYp+Xtf0rzUcQKD8YKo51E+KbRN0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    # pytz>=2023.1,<2025, but we have 2025.1
    "pytz"
  ];

  dependencies = [
    beancount-black
    beancount-parser
    beanhub-extract
    jinja2
    pydantic
    pytz
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "beanhub_import" ];

  meta = {
    description = "Declarative idempotent rule-based Beancount transaction import engine in Python";
    homepage = "https://github.com/LaunchPlatform/beanhub-import/";
    changelog = "https://github.com/LaunchPlatform/beanhub-import/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = with lib.licenses; [ mit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
