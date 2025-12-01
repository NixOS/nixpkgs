{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule rec {
  pname = "wsl2-ssh-agent";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "mame";
    repo = "wsl2-ssh-agent";
    tag = "v${version}";
    hash = "sha256-oFlp6EIh32tuqBuLlSjURpl85bzw1HymJplXoGJAM8k=";
  };

  vendorHash = "sha256-YnqpP+JkbdkCtmuhqHnKqRfKogl+tGdCG11uIbyHtlI=";

  # Need to disable some tests that require Windows to pass
  checkFlags = [ "-skip=^Test(RepeaterNormal|ServerNormal|ServerMultipleAccess|ServerRestart)$" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bridge from WSL2 ssh client to Windows ssh-agent.exe service";
    homepage = "https://github.com/mame/wsl2-ssh-agent";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "wsl2-ssh-agent";
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
