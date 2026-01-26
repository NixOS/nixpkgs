{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  mdformat,
  mdit-py-plugins,
  ruamel-yaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdformat-frontmatter";
  version = "2.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "butler54";
    repo = "mdformat-frontmatter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-snW9L9vnRHjNchhWZ5sIrn1r4piEYJeKQwib/4rarOo=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdit-py-plugins
    ruamel-yaml
  ];

  pythonImportsCheck = [ "mdformat_frontmatter" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Mdformat plugin to ensure frontmatter is respected";
    homepage = "https://github.com/butler54/mdformat-frontmatter";
    changelog = "https://github.com/butler54/mdformat-frontmatter/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aldoborrero
      polarmutex
    ];
  };
})
