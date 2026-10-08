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
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "phonopy";
    repo = "phonors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XEQcvmZ/eA7k4fBkDz9DleC7mpwQAmaG5WysDRugSlc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-TjbJpIut6Ag2PI17dgsn4Hc/7xYj8xYj4kNXSV8Akg8=";
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
