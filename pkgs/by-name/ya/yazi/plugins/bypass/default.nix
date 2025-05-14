{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bypass.yazi";
  version = "25.3.2-unstable-2025-04-22";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "17e86529b2aa8ea7c08e117debf7c55044f9edb4";
    hash = "sha256-Q5g23sCGx9Ecm350ZiGKA1OaRieECWtF1xe22WzTtdY=";
  };

  meta = {
    description = "Yazi plugin for skipping directories with only a single sub-directory.";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
