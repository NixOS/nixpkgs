{
  lib,
  stdenv,
  attrs,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  bash,
  fish,
  hatch-vcs,
  hatchling,
  markdown,
  mkdocs,
  pexpect,
  pydantic,
  pymdown-extensions,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  rich,
  rich-rst,
  sphinx,
  syrupy,
  trio,
  zsh,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyclopts";
  version = "5.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "cyclopts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Ued5ds3kw++kQt07z9p5SzYTSrV6G9IZAsjN9bxT8k=";
  };

  pythonRelaxDeps = [ "rich-rst" ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    attrs
    docstring-parser
    rich
    rich-rst
  ];

  optional-dependencies = {
    trio = [ trio ];
    yaml = [ pyyaml ];
    mkdocs = [
      mkdocs
      markdown
      pymdown-extensions
    ];
  };

  nativeCheckInputs = [
    pexpect
    pydantic
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    syrupy

    # integrations
    sphinx
    bash
    fish
    zsh
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "cyclopts" ];

  disabledTests = [
    # Building docs
    "build_succeeds"
    # timeouts under heavy concurrency
    "test_behavior[zsh-root-subcommands]"
    "test_behavior[zsh-subcommand-prefix]"
    "test_path_completion_action"
    "test_requires_equals_eq_form_value_completion"
    # zsh completion in the build sandbox returns the completion cancel
    # character instead of the candidates
    "test_e2e_option_value[zsh"
    "test_e2e_option_value_prefix[zsh"
    "test_e2e_descriptions[zsh"
    "test_e2e_subcommand_named_like_path_executable[zsh"
    "test_e2e_eq_form_option_value[zsh"
    "test_e2e_dependent_completion[zsh"
    "test_e2e_wire_protocol_forward_compat[zsh"
    "test_e2e_default_completer_positional_with_subcommands[zsh"
  ];

  meta = {
    description = "Module to create CLIs based on Python type hints";
    homepage = "https://github.com/BrianPugh/cyclopts";
    changelog = "https://github.com/BrianPugh/cyclopts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      PerchunPak
    ];
  };
})
