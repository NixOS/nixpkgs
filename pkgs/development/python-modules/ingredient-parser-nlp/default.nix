{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  nltk,
  numpy,
  pint,

  pytestCheckHook,
  nltk-data,
}:
buildPythonPackage rec {
  pname = "ingredient-parser-nlp";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strangetom";
    repo = "ingredient-parser";
    tag = version;
    hash = "sha256-l5igz4mBAqZyVu4fPBkZ+Ch9XwMOPgWQ54EZo7vdz2k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    nltk
    numpy
    pint
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ingredient_parser"
  ];

  # Needed for tests
  preCheck = ''
    export NLTK_DATA=${nltk-data.averaged-perceptron-tagger-eng}
  '';

  meta = {
    description = "Parse structured information from recipe ingredient sentences";
    license = lib.licenses.mit;
    homepage = "https://github.com/strangetom/ingredient-parser/";
    changelog = "https://github.com/strangetom/ingredient-parser/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
