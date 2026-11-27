{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  gitMinimal,
  graphviz-nox,
  hatch-fancy-pypi-readme,
  meson-python,
  meson,
  nab-index,
  nab-project,
  nab,
  ninja,
  pytest-mock,
  pytestCheckHook,
  python-sbom,
  rustPackages_1_100,
  scikit-build-core,
  setuptools-scm,
  versionCheckHook,
}:

let
  rustPackages = rustPackages_1_100;
in
buildPythonPackage (finalAttrs: {
  pname = "pipdeptree";
  version = "4.2.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pipdeptree";
    tag = finalAttrs.version;
    hash = "sha256-MrIhETMECoo1P7v/8KUwgHDq8Apcp3QMWtv6AreK2KE=";
  };

  cargoDeps = rustPackages.rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-LrhB2L75y/Ejz3TW6++PelMrVWigvV4XAU8ItAE+xQs=";
  };

  postPatch = ''
    patchShebangs tools

    substituteInPlace pyproject.toml \
      --replace-fail "\"patchelf>=0.11; sys_platform=='linux'\"," ""
  '';

  nativeBuildInputs = [
    cargo
    rustPackages.rustc
    rustPackages.rustPlatform.cargoSetupHook
  ];

  build-system = [
    hatch-fancy-pypi-readme
    meson
    meson-python
    ninja
    python-sbom
    scikit-build-core
    setuptools-scm
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
    pytest-mock
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
