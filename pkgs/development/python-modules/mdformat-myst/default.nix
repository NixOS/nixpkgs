{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdformat-frontmatter,
  mdformat-tables,
  mdit-py-plugins,
  pytestCheckHook,
  pythonOlder,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "mdformat-myst";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-myst";
    rev = "v${version}";
    hash = "sha256-soVVTQsK3axnqfmIphvz8JZCWTTyTinUtZ7I43Kte9s=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdformat-frontmatter
    mdformat-tables
    mdit-py-plugins
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_myst" ];

  meta = with lib; {
    description = "Mdformat plugin for MyST compatibility";
    homepage = "https://github.com/executablebooks/mdformat-myst";
    license = licenses.mit;
    maintainers = with maintainers; [ MattKang ];
  };
}
