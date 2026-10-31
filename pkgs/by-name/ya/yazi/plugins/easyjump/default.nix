{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "easyjump.yazi";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "mikavilpas";
    repo = "easyjump.yazi";
    tag = "v5.0.0";
    hash = "sha256-DVFh4JeXJlpw3BYQEyXMqSPx4pEGhvJ8H7SdfX/ml1E=";
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
