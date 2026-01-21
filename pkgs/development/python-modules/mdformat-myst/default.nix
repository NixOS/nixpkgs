{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdformat-footnote,
  mdformat-frontmatter,
  mdformat-tables,
  mdit-py-plugins,
  ruamel-yaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdformat-myst";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-myst";
    tag = version;
    hash = "sha256-y0zN47eK0UqTHx6ft/OrczAjdHdmPKIByCnz1c1JURQ=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdformat-footnote
    mdformat-frontmatter
    mdformat-tables
    mdit-py-plugins
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_myst" ];

  meta = {
    description = "Mdformat plugin for MyST compatibility";
    homepage = "https://github.com/executablebooks/mdformat-myst";
    changelog = "https://github.com/executablebooks/mdformat-myst/releases/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattkang ];
  };
}
