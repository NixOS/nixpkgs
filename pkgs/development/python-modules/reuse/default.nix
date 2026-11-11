{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  sphinxHook,
  furo,
  myst-parser,
  pbr,
  sphinxcontrib-apidoc,

  # dependencies
  attrs,
  binaryornot,
  boolean-py,
  click,
  python-debian,
  jinja2,
  license-expression,
  python-magic,
  tomlkit,

  # test dependencies
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "reuse";
  version = "6.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J49RIt7MxnsMJqJAaGvYgUzXMHAT9/frMmrkhWXe5tQ=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  build-system = [
    poetry-core
    sphinxHook
    furo
    myst-parser
    pbr
    sphinxcontrib-apidoc
  ];

  dependencies = [
    attrs
    binaryornot
    boolean-py
    click
    python-debian
    jinja2
    license-expression
    python-magic
    tomlkit
  ];

  nativeCheckInputs = [
    pytestCheckHook
    freezegun
  ];

  disabledTestPaths = [
    # pytest wants to execute the actual source files for some reason, which fails with ImportPathMismatchError()
    "src/reuse"
  ];

  sphinxBuilders = [
    # HACK: sphinxBuilders is currently broken with __structuredAttrs = true,
    # and ignores all but the first array item. for now, pass them as a single
    # space-separated entry. fixed on staging-next, but requires a mass-rebuild.
    # TODO: revert to [ "html" "man" ] on staging-next.
    "html man"
  ];
  sphinxRoot = "docs";

  pythonImportsCheck = [ "reuse" ];

  meta = {
    description = "Tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    changelog = "https://github.com/fsfe/reuse-tool/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      cc-by-sa-40
      cc0
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [
      FlorianFranzen
      Luflosi
    ];
    mainProgram = "reuse";
  };
})
