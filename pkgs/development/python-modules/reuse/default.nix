{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
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
  pytest-lazy-fixtures,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "reuse";
  version = "6.3.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "fsfe";
    repo = "reuse-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VxWPEKIJzLhW9l4sP9yl2+sg5kA/p7mlFXkloV1S/hM=";
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
    pytest-lazy-fixtures
  ];

  disabledTestPaths = [
    # pytest wants to execute the actual source files for some reason, which fails with ImportPathMismatchError()
    "src/reuse"
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];
  sphinxRoot = "docs";

  pythonImportsCheck = [ "reuse" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://codeberg.org/fsfe/reuse-tool";
    changelog = "https://codeberg.org/fsfe/reuse-tool/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
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
