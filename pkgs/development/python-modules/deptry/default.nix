{
  lib,
  buildPythonPackage,
  cargo,
  click,
  colorama,
  fetchFromGitHub,
  packaging,
  python,
  pytest-xdist,
  pytestCheckHook,
  requirements-parser,
  rustc,
  rustPlatform,
  tomli,
}:

buildPythonPackage (finalAttrs: {
  pname = "deptry";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osprey-oss";
    repo = "deptry";
    tag = finalAttrs.version;
    hash = "sha256-GQWivQMWQ8wi6cWsCbmvSSyPEx1yl9QidO+9mTDrN1c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-axUqKks3vxiJF2bRI/Qwk7iKjoUNQQc3NynI60n3quY=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [
    click
    colorama
    packaging
    requirements-parser
    tomli
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    cp $out/${python.sitePackages}/deptry/rust*.so python/deptry/
  '';

  disabledTestPaths = [
    # Don't run CLI tests
    "tests/functional/cli/"
  ];

  pythonImportsCheck = [ "deptry" ];

  meta = {
    description = "Find unused, missing and transitive dependencies in a Python project";
    homepage = "https://github.com/osprey-oss/deptry";
    changelog = "https://github.com/osprey-oss/deptry/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "deptry";
  };
})
