{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  poetry-core,
  phonenumbers,
  pyyaml,
  regex,
  spacy,
  tldextract,
}:

buildPythonPackage rec {
  pname = "presidio-analyzer";
  version = "2.2.360";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "presidio";
    tag = "${version}";
    hash = "sha256-q5QS1BYcOPoAfC+D5lPW1h6mqhXrr/QMO39gP7tQO0I=";
  };

  sourceRoot = "${src.name}/presidio-analyzer";

  build-system = [
    setuptools
    wheel
    poetry-core
  ];

  dependencies = [
    phonenumbers
    pyyaml
    regex
    spacy
    tldextract
  ];

  pythonImportsCheck = [ "presidio_analyzer" ];

  meta = {
    description = "PII analysis and detection tool";
    homepage = "https://github.com/microsoft/presidio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brantes ];
  };
}
