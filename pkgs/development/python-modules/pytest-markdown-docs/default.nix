{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  markdown-it-py,
  pytest,

  # tests
  mdit-py-plugins,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-markdown-docs";
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modal-com";
    repo = "pytest-markdown-docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V1volx1BckCmYwnM9Q43gRECYdccwaPWX7zUsk/+BoI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.9,<0.11.0" "uv_build"
  '';

  build-system = [ uv-build ];

  pythonRelaxDeps = [
    "markdown-it-py"
  ];
  dependencies = [
    markdown-it-py
    pytest
  ];

  pythonImportsCheck = [ "pytest_markdown_docs" ];

  nativeCheckInputs = [
    mdit-py-plugins
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "Run pytest on markdown code fence blocks";
    homepage = "https://github.com/modal-com/pytest-markdown-docs";
    changelog = "https://github.com/modal-labs/pytest-markdown-docs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
