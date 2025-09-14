{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
  sphinx,
}:

buildPythonPackage rec {
  pname = "python-docs-theme";
  version = "2025.9.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    tag = version;
    hash = "sha256-rO2L5M2TYU8+fJLDbu+EMqAy3vD7yNwd5b1fMZ8LNwg=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  pythonImportsCheck = [ "python_docs_theme" ];

  meta = {
    description = "Sphinx theme for CPython project";
    homepage = "https://github.com/python/python-docs-theme";
    changelog = "https://github.com/python/python-docs-theme/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
