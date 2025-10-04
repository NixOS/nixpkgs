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
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "georgkrause";
    repo = "language_data";
    tag = "v${version}";
    hash = "sha256-qHPie07GtVPKP/PFlP72XVVrl6j+5A8fIO729aPRsrc=";
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
