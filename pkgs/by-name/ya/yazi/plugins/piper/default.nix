{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "25.5.28-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "f9b3f8876eaa74d8b76e5b8356aca7e6a81c0fb7";
    hash = "sha256-EoIrbyC7WgRzrEtvso2Sr6HnNW91c5E+RZGqnjEi6Zo=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
