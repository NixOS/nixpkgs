{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,

  # optional-dependencies
  # audit
  packaging,
  # cli
  fire,
  rich,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  scikit-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyDeprecate";
  version = "0.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Borda";
    repo = "pyDeprecate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-byBzgr/gm/lxBbwkgOX1txp7SSFgJLM9s5hTpaUNf2I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  optional-dependencies = {
    audit = [
      packaging
    ];
    cli = [
      fire
      rich
    ];
  };

  pythonImportsCheck = [ "deprecate" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    scikit-learn
    typing-extensions
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  meta = {
    description = "Module for marking deprecated functions or classes and re-routing to the new successors' instance";
    homepage = "https://borda.github.io/pyDeprecate/";
    downloadPage = "https://github.com/Borda/pyDeprecate";
    changelog = "https://github.com/Borda/pyDeprecate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
})
