{
  buildPythonPackage,
  lib,
  fetchPypi,
  perl,
  cryptography,
  rustPlatform,
  pretend,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rfc3161-client";
  version = "1.0.0";

  src = fetchPypi {
    pname = "rfc3161_client";
    inherit version;
    hash = "sha256-YmYZ0SFUx5PANPxy/bBQQ7actMonjNsLiJGU6Hr3Fys=";
  };

  pyproject = true;

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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname;
    hash = "sha256-jpysrco+dybMwiKOa21uLKqsOeYFFERL7XKND7gPwX8=";
  };

  meta = {
    homepage = "https://github.com/trailofbits/rfc3161-client";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    changelog = "https://github.com/trailofbits/rfc3161-client/releases/tag/v${version}";
    description = "Opinionated Python RFC3161 Client";
  };
}
