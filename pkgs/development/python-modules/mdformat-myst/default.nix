{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  mdformat,
  mdformat-footnote,
  mdformat-front-matters,
  mdformat-gfm,
  mdit-py-plugins,
  ruamel-yaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdformat-myst";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-myst";
    tag = finalAttrs.version;
    hash = "sha256-y0zN47eK0UqTHx6ft/OrczAjdHdmPKIByCnz1c1JURQ=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdformat-footnote
    mdformat-front-matters
    mdformat-gfm
    mdit-py-plugins
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_myst" ];

  meta = {
    description = "Mdformat plugin for MyST compatibility";
    homepage = "https://github.com/executablebooks/mdformat-myst";
    changelog = "https://github.com/executablebooks/mdformat-myst/releases/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattkang ];
  };
})
