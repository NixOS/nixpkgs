{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  setuptools,

  nltk,
  python-crfsuite,
  pint,
  floret,

  pytestCheckHook,
  nltk-data,
}:
buildPythonPackage rec {
  pname = "ingredient-parser-nlp";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strangetom";
    repo = "ingredient-parser";
    tag = version;
    hash = "sha256-i14RKBcvU56pDNGxNVBvvpQ65FCbitMIfvN5eLLJCWU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    nltk
    python-crfsuite
    pint
    floret
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ingredient_parser"
  ];

  # Needed for tests
  preCheck = ''
    export NLTK_DATA=${nltk-data.averaged_perceptron_tagger_eng}
  '';

  meta = {
    description = "Parse structured information from recipe ingredient sentences";
    license = lib.licenses.mit;
    homepage = "https://github.com/strangetom/ingredient-parser/";
    changelog = "https://github.com/strangetom/ingredient-parser/releases/tag/${version}";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
