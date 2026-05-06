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
    rev = "93fa80b0687ffb9c4507694be06b0148ba8966c2";
    hash = "sha256-8Us8WbEC9L7VdHT3gd7OYqJdGi7WWyV6gLMXR6n2TMg=";
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
