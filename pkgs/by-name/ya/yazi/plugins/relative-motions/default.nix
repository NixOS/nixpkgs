{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "relative-motions.yazi";
  version = "25.5.28-unstable-2025-06-05";

  src = fetchFromGitHub {
    owner = "dedukun";
    repo = "relative-motions.yazi";
    rev = "2e3b6172e6226e0db96aea12d09dea2d2e443fea";
    hash = "sha256-v0e06ieBKNmt9DATdL7R4AyVFa9DlNBwpfME3LHozLA=";
  };

  meta = {
    description = "Yazi plugin based about vim motions";
    homepage = "https://github.com/dedukun/relative-motions.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
