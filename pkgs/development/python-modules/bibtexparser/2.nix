{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pylatexenc,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bibtexparser";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-bibtexparser";
    tag = "v${version}";
    hash = "sha256-ZapMA1x+DUjZuq7RAK3pADuPJuvWXyEuDBfLcEf+Z7Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ pylatexenc ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bibtexparser" ];

  meta = {
    description = "Bibtex parser for Python";
    homepage = "https://github.com/sciunto-org/python-bibtexparser";
    changelog = "https://github.com/sciunto-org/python-bibtexparser/blob/${src.tag}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
