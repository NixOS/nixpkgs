{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tab-rs";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "austinjones";
    repo = "tab-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2fHyVTkVT4V97jM4hWsTCZ1TNWBk/JncMcbGGhUDMrM=";
  };

  cargoHash = "sha256-4bscAhYE3JNk4ikTH+Sw2kGDDsBWcCZZ88weg9USjC0=";

  # many tests are failing
  doCheck = false;

  meta = {
    description = "Intuitive, config-driven terminal multiplexer designed for software & systems engineers";
    homepage = "https://github.com/austinjones/tab-rs";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tab";
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # Added 2023-11-13
  };
})
