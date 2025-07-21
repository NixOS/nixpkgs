{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "glow.yazi";
  version = "0-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "2da96e3ffd9cd9d4dd53e0b2636f83ff69fe9af0";
    hash = "sha256-4krck4U/KWmnl32HWRsblYW/biuqzDPysrEn76buRck=";
  };

  meta = {
    description = "Glow preview plugin for yazi";
    homepage = "https://github.com/Reledia/glow.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
