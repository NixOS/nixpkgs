{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  binaryornot,
  boolean-py,
  debian,
  jinja2,
  license-expression,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reuse";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZYmQtJ503HDmu+Cd6IxOrCcOVH+CcFnFe3oe6PqvcE0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    binaryornot
    boolean-py
    debian
    jinja2
    license-expression
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # pytest wants to execute the actual source files for some reason, which fails with ImportPathMismatchError()
    "src/reuse"
  ];

  pythonImportsCheck = [ "reuse" ];

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
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
