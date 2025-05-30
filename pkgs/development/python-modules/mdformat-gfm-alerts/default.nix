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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-gfm-alerts";
    tag = "v${version}";
    hash = "sha256-7sZ16qkYvqR2o4ogU2op+oB/0+jeGLgHuvMRe+mZtbQ=";
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
    changelog = "https://github.com/KyleKing/mdformat-gfm-alerts/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    broken = true; # broken test due to changes in mdformat; compare https://github.com/KyleKing/mdformat-admon/issues/25
  };
}
