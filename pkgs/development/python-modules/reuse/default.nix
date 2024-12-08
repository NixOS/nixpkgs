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
  debian,
  jinja2,
  license-expression,
  tomlkit,

  # test dependencies
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reuse";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-MzI3AY5WLNyCLJZM7Q5wUH3ttx+FHPlSgAfngzOgzec=";
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
    debian
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
