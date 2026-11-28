{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lxml,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "citeproc-py-styles";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "citeproc-py-styles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4yIU/n/qKDGUVGAjPXY9fzqKnH0fByR6SOrJqmAhoeA=";
    fetchSubmodules = true;
  };

  build-system = [ hatchling ];

  dependencies = [ lxml ];

  # Tests are additional requirements
  doCheck = false;

  pythonImportsCheck = [ "citeproc_styles" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CSL styles for citeproc-py";
    homepage = "https://github.com/inveniosoftware/citeproc-py-styles";
    changelog = "https://github.com/inveniosoftware/citeproc-py-styles/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
