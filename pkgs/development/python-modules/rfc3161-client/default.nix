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

buildPythonPackage rec {
  pname = "rfc3161-client";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "rfc3161-client";
    tag = "v${version}";
    hash = "sha256-C5wz9sj5TmZudqtAlL3c8ffJ7XjJ+FuimRA0vWpm/A8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname;
    hash = "sha256-EUQbdfR4xS6XBmIzBL4BF3NzDI2P6F8I4Khl2KOSSZ0=";
  };

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
    changelog = "https://github.com/trailofbits/rfc3161-client/releases/tag/v${version}";
    description = "Opinionated Python RFC3161 Client";
  };
}
