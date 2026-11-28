{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  nix-update-script,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "phonors";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phonopy";
    repo = "phonors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RvZf9CXPO2NTGVjhY0SWvd+DmOce/QZ6QtqRuHk+r4g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-0rxfHY5heyvISrkuGU/YiPqgysojKFRm7RN7Zyyw9QA=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "phonors" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python module implemented in Rust for Phonopy";
    homepage = "https://github.com/phonopy/phonors";
    changelog = "https://github.com/phonopy/phonors/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
