{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cargo,
  rustPlatform,
  rustc,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "multi-demangle";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AppThreat";
    repo = "multi-demangle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zzTgBfOR+GblrRNmTKgFMcY/rT4Dds5aszXblEhc428=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-YTNsnrb6ev9mWE8WcSRZa1337ex2hjzm4QkJPdV3NPQ=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [
    "multi_demangle"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Demangling support for various languages and compilers";
    homepage = "https://github.com/AppThreat/multi-demangle";
    changelog = "https://github.com/AppThreat/multi-demangle/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
