{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tab-rs";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "austinjones";
    repo = "tab-rs";
    rev = "v${version}";
    sha256 = "1crj0caimin667f9kz34c0sm77892dmqaf1kxryqakqm75az5wfr";
  };

  cargoHash = "sha256-4bscAhYE3JNk4ikTH+Sw2kGDDsBWcCZZ88weg9USjC0=";

  # many tests are failing
  doCheck = false;

  meta = with lib; {
    description = "Intuitive, config-driven terminal multiplexer designed for software & systems engineers";
    homepage = "https://github.com/austinjones/tab-rs";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "tab";
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # Added 2023-11-13
  };
}
