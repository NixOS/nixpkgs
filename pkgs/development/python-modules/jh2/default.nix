{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "jh2";
  version = "5.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "h2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zlc0R+DeE9bd5daD7sUrGHXU3NR5tRiiFvBrccSKCTI=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-BPTgGc/qH101ZBlqiqwBe5KXXpnpDGe5K6GLqG99GSI=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jh2" ];

  meta = {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "https://github.com/jawah/h2";
    changelog = "https://github.com/jawah/h2/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      techknowlogick
    ];
  };
})
