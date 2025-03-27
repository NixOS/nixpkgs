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
  version = "2025.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    tag = version;
    hash = "sha256-+QOtlgWGPcuKZOfuE0l08GUetR0DZvMzsk8Xl8KaZcQ=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  pythonImportsCheck = [ "python_docs_theme" ];

  meta = with lib; {
    description = "Sphinx theme for CPython project";
    homepage = "https://github.com/python/python-docs-theme";
    changelog = "https://github.com/python/python-docs-theme/blob/${version}/CHANGELOG.rst";
    license = licenses.psfl;
    maintainers = with maintainers; [ kaction ];
  };
}
