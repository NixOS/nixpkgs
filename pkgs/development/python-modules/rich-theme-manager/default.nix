{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rich-theme-manager";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhetTbull";
    repo = "rich_theme_manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-nSNG+lWOPmh66I9EmPvWqbeceY/cu+zBpgVlDTNuHc0=";
  };

  build-system = [ poetry-core ];
  dependencies = [ rich ];

  pythonImportsCheck = [ "rich_theme_manager" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Define custom styles and themes for use with rich";
    license = lib.licenses.mit;
    homepage = "https://github.com/RhetTbull/rich_theme_manager";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
