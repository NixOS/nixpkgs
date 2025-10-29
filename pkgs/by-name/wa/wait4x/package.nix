{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "wait4x";
  version = "3.6.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${version}";
    hash = "sha256-RiF5tcnzMteXaYmw4mfQdamwV1PAyNC8pUownJzfACs=";
  };

  vendorHash = "sha256-fa3XEqLkzriMFYea3bv4FzaKgK2FsGwn5IQG48vh7+M=";

  # Tests make network access
  doCheck = false;

  meta = with lib; {
    description = "Allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/wait4x/wait4x";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
}
