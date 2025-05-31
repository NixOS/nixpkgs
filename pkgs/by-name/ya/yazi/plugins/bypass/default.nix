{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bypass.yazi";
  version = "25.3.2-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "381fb89a21a58605c555c109f190309b2d116d30";
    hash = "sha256-04cyOlG843Ot+jRT8GNFjJOzV4YdPBpI9XqbaK6KXu0=";
  };

  meta = {
    description = "Yazi plugin for skipping directories with only a single sub-directory.";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
