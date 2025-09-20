{
  buildGoModule,
  fetchFromGitHub,
  lib,
  ...
}:
buildGoModule rec {
  pname = "wsl2-ssh-agent";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "mame";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-oFlp6EIh32tuqBuLlSjURpl85bzw1HymJplXoGJAM8k=";
  };

  vendorHash = "sha256-YnqpP+JkbdkCtmuhqHnKqRfKogl+tGdCG11uIbyHtlI=";

  # Need to disable some tests that require Windows to pass
  checkFlags = [ "-skip=^Test(RepeaterNormal|ServerNormal|ServerMultipleAccess|ServerRestart)$" ];

  meta = {
    description = "A bridge from WSL2 ssh client to Windows ssh-agent.exe service";
    homepage = "https://github.com/mame/wsl2-ssh-agent";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
