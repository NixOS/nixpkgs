{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  perl,
  cryptography,
  openssl,
  pkg-config,
  rustPlatform,
  pretend,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rfc3161-client";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "rfc3161-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3O2cOBT7ObhCxAyNyOktLF/ZQvrGkyfk2nmlric4oo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname;
    hash = "sha256-YCn/MDSDgrntbFZBJ9eQ5KM74fx7+r0aMdW3jOGJ5+w=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    openssl
  ];

  dependencies = [
    cryptography
  ];

  nativeCheckInputs = [
    pretend
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
