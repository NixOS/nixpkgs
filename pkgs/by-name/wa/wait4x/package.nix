{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "wait4x";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "wait4x";
    repo = "wait4x";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JUg7aIpIa9/b7Fz/cSZs9tZxX/cpCm5xK/HSVq5T7Zk=";
  };

  vendorHash = "sha256-oyEPEaCSr847Eo5KPke3AjbzOwyP4moBbZJVeorw4QQ=";

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
