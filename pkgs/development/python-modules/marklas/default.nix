{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  mistune,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "marklas";
  version = "0.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "byExist";
    repo = "marklas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vzjU1a/uWho9SpPO7RC3fgs3iXnh8BD3uCLTnZge2Po=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.21,<0.10.0" "uv_build>=0.9.21"
  '';

  build-system = [ uv-build ];

  dependencies = [ mistune ];

  pythonImportsCheck = [ "marklas" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Bidirectional converter between GitHub Flavored Markdown and Atlassian Document Format";
    homepage = "https://github.com/byExist/marklas";
    changelog = "https://github.com/byExist/marklas/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caspersonn ];
  };
})
