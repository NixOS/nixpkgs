{
  lib,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule {
  pname = "systemd-openbaod";
  version = "0.0.0-unstable-2025-10-06";
  src = fetchFromGitea {
    domain = "git.lix.systems";
    owner = "the-distro";
    repo = "systemd-openbao";
    rev = "2479c46b0fa892c4fdcd3e315f0cdfe096b5e71a";
    hash = "sha256-n8cyDX5qitjTNFQ2+nUeOpqSkXREir9p2bSqOZZ5sLs=";
  };
  vendorHash = null;
  meta = {
    description = "Proxy for secrets between systemd services and openbao";
    homepage = "https://git.lix.systems/the-distro/systemd-openbao.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
    platforms = lib.platforms.unix;
    mainProgram = "systemd-openbaod";
  };
}
