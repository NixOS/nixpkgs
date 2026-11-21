{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "teetty";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "teetty";
    rev = version;
    hash = "sha256-L5GlmbscAt6aqt79qq5UAeMeDscvpYUwjJZcSESMVj4=";
  };

  cargoHash = "sha256-fJ4TgQddr+OrvhSZFWcKyOvwkfBVQODHmq8E7nBOEZk=";

  meta = {
    description = "A bit like tee, a bit like script, but all with a fake tty. Lets you remote control and watch a process";
    homepage = "https://github.com/mitsuhiko/teetty";
    changelog = "https://github.com/mitsuhiko/teetty/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rehno-lindeque ];
    mainProgram = "teetty";
  };
}
