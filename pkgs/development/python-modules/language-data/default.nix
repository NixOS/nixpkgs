{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marisa-trie,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "language-data";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "georgkrause";
    repo = "language_data";
    rev = "refs/tags/v${version}";
    hash = "sha256-TVWyDEDI6NBioc8DqhXzpLS22EFKsZ/nan2vfgFsieQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ marisa-trie ];

  pythonImportsCheck = [ "language_data" ];

  # No unittests
  doCheck = false;

  meta = with lib; {
    description = "Supplement module for langcodes";
    homepage = "https://github.com/georgkrause/language_data";
    changelog = "https://github.com/georgkrause/language_data/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
