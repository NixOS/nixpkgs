{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-metadata,
  importlib-resources,
  jinja2,
  mkdocs,
  pyparsing,
  pyyaml,
  pyyaml-env-tag,
  verspec,
  versionCheckHook,
  pytestCheckHook,
  git,
  shtab,
  stdenv,
}:

buildPythonPackage rec {
  pname = "mike";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jimporter";
    repo = "mike";
    tag = "v${version}";
    hash = "sha256-eGUkYcPTrXwsZPqyDgHJlEFXzhMnenoZsjeHVGO/9WU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    importlib-metadata
    importlib-resources
    jinja2
    mkdocs
    pyparsing
    pyyaml
    pyyaml-env-tag
    verspec
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    git
    mkdocs
    shtab
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  ''
  # "stat" on darwin results in "not permitted" instead of "does not exists"
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace test/unit/test_git_utils.py \
      --replace-fail "/home/nonexist" "$(mktemp -d)"
  '';

  pythonImportsCheck = [ "mike" ];

  meta = {
    description = "Manage multiple versions of your MkDocs-powered documentation via Git";
    homepage = "https://github.com/jimporter/mike";
    changelog = "https://github.com/jimporter/mike/blob/v${version}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ marcel ];
    mainProgram = "mike";
  };
}
