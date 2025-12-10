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
  version = "2025.10";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    tag = version;
    hash = "sha256-vuQsGHj39znL3RvSvnc9ET1g30/FcSnDnFby2bm84hY=";
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
