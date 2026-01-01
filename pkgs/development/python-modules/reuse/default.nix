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

buildPythonPackage rec {
  pname = "reuse";
  version = "6.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    tag = "v${version}";
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
    "html"
    "man"
  ];
  sphinxRoot = "docs";

  pythonImportsCheck = [ "reuse" ];

<<<<<<< HEAD
  meta = {
    description = "Tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    changelog = "https://github.com/fsfe/reuse-tool/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    changelog = "https://github.com/fsfe/reuse-tool/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      cc-by-sa-40
      cc0
      gpl3Plus
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      FlorianFranzen
      Luflosi
    ];
    mainProgram = "reuse";
  };
}
