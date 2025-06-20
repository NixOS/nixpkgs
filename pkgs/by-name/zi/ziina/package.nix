{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ziina";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ziinaio";
    repo = "ziina";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kRg7MLp5hxvVhCetjp3I9v8NlgFSHo2vVhW6VK08FEM=";
  };

  vendorHash = "sha256-o4RQ2feBP/qt7iv8jUb1zyHJzurjqh+dW3W5qjEuO1o=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Instant terminal sharing; using Zellij";
    mainProgram = "ziina";
    homepage = "https://github.com/ziinaio/ziina";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
})
