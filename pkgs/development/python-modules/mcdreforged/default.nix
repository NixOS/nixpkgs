{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  versionCheckHook,

  colorama,
  colorlog,
  packaging,
  parse,
  pathspec,
  prompt-toolkit,
  psutil,
  requests,
  resolvelib,
  ruamel-yaml,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcdreforged";
  version = "2.15.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MCDReforged";
    repo = "MCDReforged";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e1JrDh8Zio+TCVCVvH8tBE/tY5ja3Nr3dCQRJwRqYh4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    colorlog
    packaging
    parse
    pathspec
    prompt-toolkit
    psutil
    requests
    resolvelib
    ruamel-yaml
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail 'ruamel.yaml~=0.17,<0.19' 'ruamel.yaml==${ruamel-yaml.version}'
  '';

  meta = {
    changelog = "https://github.com/MCDReforged/MCDReforged/releases/tag/${finalAttrs.src.tag}";
    longDescription = ''
      MCDReforged (abbreviated as MCDR) is a tool which provides the
      management ability of the Minecraft server using custom plugin
      system.  It doesn't need to modify or mod the original Minecraft
      server at all.

      From in-game calculator, player high-light, to manipulate
      scoreboard, manage structure file and backup / load backup, you
      can implement these by using MCDR and related plugins.
    '';
    description = "Minecraft server control tool";
    homepage = "https://mcdreforged.com";
    license = lib.licenses.lgpl3Only;
    mainProgram = "mcdreforged";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
