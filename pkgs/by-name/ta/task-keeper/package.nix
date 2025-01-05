{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    tag = "v${version}";
    hash = "sha256-ufKHKQULN1zaEmnLx4voL/rL8bBe0aZEfclb+5/ybps=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  cargoHash = "sha256-g2CxCpSBAKUn+ENduuh+u5l3KD7rchY0qLAuPz8ATww=";

  # tests depend on many packages (java, node, python, sbt, ...) - which I'm not currently willing to set up 😅
  doCheck = false;

  meta = {
    homepage = "https://github.com/linux-china/task-keeper";
    description = "CLI to manage tasks from different task runners or package managers";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tennox ];
    mainProgram = "tk";
  };
}
