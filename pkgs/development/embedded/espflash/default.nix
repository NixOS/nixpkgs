{ lib
, rustPlatform
, fetchCrate
, pkg-config
, stdenv
, udev
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "espflash";
  version = "2.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Gd+8pA36mO+BCA0EFshboBi0etNjsiQFQU1wBYf/o6I=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  cargoHash = "sha256-IObAbsyrVBXt5zldirRezU7vS3R3aUihMFy2yIRWIlk=";

  meta = with lib; {
    description = "Serial flasher utility for Espressif SoCs and modules";
    homepage = "https://github.com/esp-rs/espflash";
    changelog = "https://github.com/esp-rs/espflash/blob/v${version}/CHANGELOG.md";
    mainProgram = "espflash";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
