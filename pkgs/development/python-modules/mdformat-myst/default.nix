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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-myst";
    tag = "v${version}";
    hash = "sha256-Ty9QOsOTCNfhdLVuLfD0x63OFfHhODr14i/dhN+Sqnc=";
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
    changelog = "https://github.com/executablebooks/mdformat-myst/releases/tag/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mattkang ];
  };
}
