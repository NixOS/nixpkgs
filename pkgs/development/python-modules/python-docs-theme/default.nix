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
  version = "2025.9.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    tag = version;
    hash = "sha256-G9QhrNqwSonyCQXxBv1GkUx39GyOQs+0gciJDQwWvVQ=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  pythonImportsCheck = [ "python_docs_theme" ];

  meta = with lib; {
    description = "Sphinx theme for CPython project";
    homepage = "https://github.com/python/python-docs-theme";
    changelog = "https://github.com/python/python-docs-theme/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.psfl;
    maintainers = with maintainers; [ kaction ];
  };
}
