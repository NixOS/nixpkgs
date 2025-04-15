{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "glow.yazi";
  version = "0-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "a1711f10e815f7f7b6e529e0814342b8518d9ee6";
    hash = "sha256-4krck4U/KWmnl32HWRsblYW/biuqzDPysrEn76buRck=";
  };

  meta = {
    description = "Glow preview plugin for yazi";
    homepage = "https://github.com/Reledia/glow.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
