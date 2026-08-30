{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sudo.yazi";
  version = "0-unstable-2026-08-26";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "sudo.yazi";
    rev = "74e17fe22810521430223ed10fb997cdce5c008d";
    hash = "sha256-+wjSDVkeL4K/1wVAPL7qph6TCMTWF/WYUghw4ggNYa8=";
  };

  meta = {
    description = "Call `sudo` in yazi";
    homepage = "https://github.com/TD-Sky/sudo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
