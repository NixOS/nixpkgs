{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    tag = "v${version}";
    hash = "sha256-D+aAqyJ7DzkaGHY+MEItcxQwuNKXzZhV/0HVj5WMqn0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  useFetchCargoVendor = true;
  cargoHash = "sha256-asmdiJJmm+59vts0tkKDo7gkHOXbRM6FQWhdjfZ3w7U=";

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
