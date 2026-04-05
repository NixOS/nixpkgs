{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  poetry-core,
  presidio-analyzer,
  spacy,
  cryptography,
}:

buildPythonPackage rec {
  pname = "presidio-anonymizer";
  version = "2.2.360";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "presidio";
    tag = "${version}";
    hash = "sha256-q5QS1BYcOPoAfC+D5lPW1h6mqhXrr/QMO39gP7tQO0I=";
  };

  sourceRoot = "${src.name}/presidio-anonymizer";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"cryptography (<44.1)"' '"cryptography"'
  '';

  build-system = [
    setuptools
    wheel
    poetry-core
  ];

  dependencies = [
    presidio-analyzer
    spacy
    cryptography
  ];

  pythonImportsCheck = [ "presidio_anonymizer" ];

  meta = {
    description = "PII anonymization module";
    homepage = "https://github.com/microsoft/presidio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brantes ];
  };
}
