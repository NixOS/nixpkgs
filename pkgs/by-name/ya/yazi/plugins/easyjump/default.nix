{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "easyjump.yazi";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "mikavilpas";
    repo = "easyjump.yazi";
    tag = "v3.0.0";
    hash = "sha256-ecrBur2bTV805WR5JS8xx01Fn/Y6JLwuZJK8Xvl2kgc=";
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
