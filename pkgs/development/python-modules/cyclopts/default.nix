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
  version = "4.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "cyclopts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uKeGQw/vWDOtRi+CGNHfMAf/ofZyEfRqp2fUUWaIEDs=";
  };

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
    # https://github.com/BrianPugh/cyclopts/issues/820
    "test_behavior[fish-literal-positional]"
    "test_behavior[fish-multi-positional-second]"
    "test_behavior[fish-equals-form-option-value]"
    "test_behavior[fish-multi-positional-third]"
  ]
  # https://github.com/BrianPugh/cyclopts/issues/821
  ++ lib.lists.optional (
    stdenv.hostPlatform.system == "aarch64-linux"
  ) "test_collection_option_repeats";

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
