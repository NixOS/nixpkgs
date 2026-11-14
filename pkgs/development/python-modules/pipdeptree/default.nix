{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  gitMinimal,
  graphviz-nox,
  meson,
  meson-python,
  nab,
  nab-index,
  nab-project,
  ninja,
  pytestCheckHook,
  rustc,
  rustPlatform,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pipdeptree";
  version = "4.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pipdeptree";
    tag = finalAttrs.version;
    hash = "sha256-PHuwLe0ITPWaA06SYC7tZ1jcbPEMCIMCfAEUWsET5Fc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-5EqZBM+Gv47cCrwbl6oPNgP43zNcsvrtRnEVFu/WbRk=";
  };

  postPatch = ''
    patchShebangs tools

    substituteInPlace pyproject.toml \
      --replace-fail "meson-python>=0.22.1" meson-python
  '';

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  build-system = [
    meson
    meson-python
    ninja
  ];

  dontUseMesonConfigure = true;

  env.PIPDEPTREE_VERSION = finalAttrs.version;

  dependencies = [
    nab
    nab-index
    nab-project
  ];

  nativeCheckInputs = [
    gitMinimal
    graphviz-nox
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "pipdeptree" ];

  meta = {
    description = "Command line utility to show dependency tree of packages";
    homepage = "https://github.com/tox-dev/pipdeptree";
    changelog = "https://github.com/tox-dev/pipdeptree/blob/${finalAttrs.src.rev}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      charlesbaynham
      mdaniels5757
    ];
    mainProgram = "pipdeptree";
  };
})
