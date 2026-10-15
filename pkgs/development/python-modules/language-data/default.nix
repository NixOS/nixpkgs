{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marisa-trie,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "language-data";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "georgkrause";
    repo = "language_data";
    tag = "v${version}";
    hash = "sha256-cWjeb2toGrnNSsK566e18NgWhv6YdQrKEzFPilmBdoA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ marisa-trie ];

  pythonImportsCheck = [ "language_data" ];

  # No unittests
  doCheck = false;

  meta = {
    description = "Supplement module for langcodes";
    homepage = "https://github.com/georgkrause/language_data";
    changelog = "https://github.com/georgkrause/language_data/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
