{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "lazygit.yazi";
  version = "0-unstable-2026-03-12";

  src = fetchFromGitHub {
    owner = "Lil-Dank";
    repo = "lazygit.yazi";
    rev = "8c4086c813c5856ab9571ae9142ed7d40ed3211e";
    hash = "sha256-YpRWnR5fEXzHY9yBFNKy1NvTzHa8B1UhS2Qrfe9+Tpg=";
  };

  meta = {
    description = "Lazygit plugin for yazi";
    homepage = "https://github.com/Lil-Dank/lazygit.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
