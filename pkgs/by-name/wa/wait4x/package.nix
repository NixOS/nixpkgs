{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wait4x";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RiF5tcnzMteXaYmw4mfQdamwV1PAyNC8pUownJzfACs=";
  };

  vendorHash = "sha256-fa3XEqLkzriMFYea3bv4FzaKgK2FsGwn5IQG48vh7+M=";

  # Tests make network access
  doCheck = false;

  meta = {
    description = "Allows you to wait for a port or a service to enter the requested state";
    homepage = "https://github.com/wait4x/wait4x";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    mainProgram = "wait4x";
  };
})
