{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    tag = "v${version}";
    hash = "sha256-PT8NN6rHY9Ph15KikoAYAfJ++u6t6Mp8SPm24ZBdPDk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  useFetchCargoVendor = true;
  cargoHash = "sha256-6KnZDSYPf3Rr9II/lsrPvzRMiwOknrstU8/91mv7x8k=";

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
