{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "25.9.15-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "c179ea49753b3a784935986d36b077a6df24bdb3";
    hash = "sha256-0VKoUusTmKVxW8fJkYf0lm17bMjvkN1/tmx7+pNJdWI=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
