{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    tag = "v${version}";
    hash = "sha256-/ZmwCvoYdX733c5QkUE0KuUdHeibJkXD5wNHR7Cr7aU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-Z56p2jeHvNAT4Pwl8kt1l9RopYCKk5Tt/XWZ7AqIFYw=";

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
