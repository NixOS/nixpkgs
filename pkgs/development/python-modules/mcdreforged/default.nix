{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  colorama,
  colorlog,
  packaging,
  parse,
  prompt-toolkit,
  psutil,
  requests,
  resolvelib,
  ruamel-yaml,
  typing-extensions,
  pathspec,
  pytestCheckHook,
  versionCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "mcdreforged";
  version = "2.14.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MCDReforged";
    repo = "MCDReforged";
    tag = "v${version}";
    hash = "sha256-R9zM86ohABEaxj7NYj8FCPIYsMDJp0sKjOhWzit69B8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    colorlog
    packaging
    parse
    prompt-toolkit
    psutil
    requests
    resolvelib
    ruamel-yaml
    typing-extensions
    pathspec
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rewritten version of MCDaemon, a python tool to control your Minecraft server";
    homepage = "https://mcdreforged.com";
    changelog = "https://github.com/MCDReforged/MCDReforged/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mcdreforged";
  };
}
