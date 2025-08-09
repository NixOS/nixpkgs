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
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "rfc3161-client";
    tag = "v${version}";
    hash = "sha256-1TdJGaiDS+ktmry0c294likWj8bbwaNkcUM7Q2f1YPU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname;
    hash = "sha256-jQsogV+qR0jAkHz/Slg9oBO/f96osU8YcjuaX4ZJQTk=";
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
    changelog = "https://github.com/trailofbits/rfc3161-client/releases/tag/v${version}";
    description = "Opinionated Python RFC3161 Client";
  };
}
