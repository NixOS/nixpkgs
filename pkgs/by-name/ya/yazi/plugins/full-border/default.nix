{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "full-border.yazi";
  version = "25.2.26-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "f9b3f8876eaa74d8b76e5b8356aca7e6a81c0fb7";
    hash = "sha256-EoIrbyC7WgRzrEtvso2Sr6HnNW91c5E+RZGqnjEi6Zo=";
  };

  meta = {
    description = "Add a full border to Yazi to make it look fancier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
