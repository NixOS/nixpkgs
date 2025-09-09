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
  tomlkit,

  # test dependencies
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reuse";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    tag = "v${version}";
    hash = "sha256-xrYr68PpTLglTlLgTHWHJjTd62tzcOvY9h//CxYJOzM=";
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
    "html"
    "man"
  ];
  sphinxRoot = "docs";

  pythonImportsCheck = [ "reuse" ];

  meta = with lib; {
    description = "Tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    changelog = "https://github.com/fsfe/reuse-tool/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      cc-by-sa-40
      cc0
      gpl3Plus
    ];
    maintainers = with maintainers; [
      FlorianFranzen
      Luflosi
    ];
    mainProgram = "reuse";
  };
}
