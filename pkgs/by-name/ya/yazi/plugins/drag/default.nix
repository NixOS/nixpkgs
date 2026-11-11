{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "drag.yazi";
  version = "0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "Joao-Queiroga";
    repo = "drag.yazi";
    rev = "5f6b284245086010f92403536409a6249f73f1f2";
    hash = "sha256-VHuSCi106iP8EEwLdY91eD64kUJEye7vVHjf6sIdpQA=";
  };

  meta = {
    description = "Yazi plugin to drag and drop files using ripdrag";
    homepage = "https://github.com/Joao-Queiroga/drag.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gibbert ];
  };
}
