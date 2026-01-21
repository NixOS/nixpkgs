{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "lazygit.yazi";
  version = "0-unstable-2025-12-31";

  src = fetchFromGitHub {
    owner = "Lil-Dank";
    repo = "lazygit.yazi";
    rev = "0e56060192d1ccd307664bf93b3d0beb1efe528e";
    hash = "sha256-LcEpzSf0E43hnhOxJ/EHNJRk3Au5hcgRZ2Kj412Ykew=";
  };

  meta = {
    description = "Lazygit plugin for yazi";
    homepage = "https://github.com/Lil-Dank/lazygit.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
