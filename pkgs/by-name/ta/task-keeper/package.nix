{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    tag = "v${version}";
    hash = "sha256-89KR1u4aTd32tGPiW4qUUk9eC7d9pGSBuZ8C8QVgMQ4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-eLdGLKem/Sh9cQ7TRbKymUIldpctBKk1JBjWiSwLloo=";

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
