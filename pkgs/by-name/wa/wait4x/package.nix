{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wait4x";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${finalAttrs.version}";
    hash = "sha256-07+6noaevhkr9MqMFquEDpPKcNJSzHMIL2qREwX3tjM=";
  };

  vendorHash = "sha256-qsVXm0W8R0xjlN4jvE70tmCr8WFScX7zMbtYR0LmJdg=";

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
