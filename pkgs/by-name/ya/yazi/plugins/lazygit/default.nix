{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "lazygit.yazi";
  version = "0-unstable-2025-12-19";

  src = fetchFromGitHub {
    owner = "Lil-Dank";
    repo = "lazygit.yazi";
    rev = "ea20d05b4ede88a239830d2b50ba79b1860a3bee";
    hash = "sha256-uDRd2pDgvYAwrnsKg5U/Dj8ZPtNKzlJRg+YARKjSpCw=";
  };

  meta = {
    description = "Lazygit plugin for yazi";
    homepage = "https://github.com/Lil-Dank/lazygit.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
