{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  perl,
  cryptography,
  rustPlatform,
  pretend,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rfc3161-client";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "rfc3161-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ztszylefOKYqmvJsevM1T18C4oLC6AXRbbUT8DXTjEI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname;
    hash = "sha256-ntqiITOKBIGpvuYj1fUrIsP+AGPlHtOXt0IApwLYNWY=";
  };

  pythonRelaxDeps = [
    "cryptography"
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    perl
  ];

  dependencies = [
    cryptography
    pretend
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/trailofbits/rfc3161-client";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    changelog = "https://github.com/trailofbits/rfc3161-client/releases/tag/${finalAttrs.src.tag}";
    description = "Opinionated Python RFC3161 Client";
  };
})
