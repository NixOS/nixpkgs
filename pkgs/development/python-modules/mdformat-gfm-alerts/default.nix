{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdit-py-plugins,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdformat-gfm-alerts";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-gfm-alerts";
    rev = "refs/tags/v${version}";
    hash = "sha256-2EYdNCyS1LxcEnCXkOugAAGx5XLWV4cWTNkXjR8RVQo=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdit-py-plugins
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mdformat_gfm_alerts" ];

  meta = {
    description = "Format 'GitHub Markdown Alerts', which use blockquotes to render admonitions";
    homepage = "https://github.com/KyleKing/mdformat-gfm-alerts";
    changelog = "https://github.com/KyleKing/mdformat-gfm-alerts/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
