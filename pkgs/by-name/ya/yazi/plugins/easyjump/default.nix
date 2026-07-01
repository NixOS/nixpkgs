{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "easyjump.yazi";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mikavilpas";
    repo = "easyjump.yazi";
    rev = "7c4056ec691c4da9c16dc98802366782e5e012a5";
    hash = "sha256-uJRxk7kF0qn6WSP/2WhNnQK3kvsaUJfAozOGweSXiDA=";
  };

  sourceRoot = "source/easyjump.yazi";

  meta = {
    description = "Yazi plugin for quickly jumping to the visible files";
    homepage = "https://github.com/mikavilpas/easyjump.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      philocalyst
    ];
  };
}
