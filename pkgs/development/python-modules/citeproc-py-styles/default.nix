{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lxml,
  nix-update-script,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "citeproc-py-styles";
  version = "0.1.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "citeproc-py-styles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l3oz6iQ6zQbX89FXnYJZcCKdLUSeXPHz3fTDBhcrzd0=";
    fetchSubmodules = true;
  };

  build-system = [ hatchling ];

  dependencies = [
    lxml
    six
  ];

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
