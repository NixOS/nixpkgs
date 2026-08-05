{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-docs-theme";
  version = "2026.4";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "python";
    repo = "python-docs-theme";
    tag = finalAttrs.version;
    hash = "sha256-wfHon11V7fvK+PMWBY+MpxiPOyqIecRAu+rM4uONMzA=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  pythonImportsCheck = [ "python_docs_theme" ];

  meta = {
    description = "Sphinx theme for CPython project";
    homepage = "https://github.com/python/python-docs-theme";
    changelog = "https://github.com/python/python-docs-theme/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ kaction ];
  };
})
