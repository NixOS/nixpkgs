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
}:

buildPythonPackage rec {
  pname = "mcdreforged";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MCDReforged";
    repo = "MCDReforged";
    tag = "v${version}";
    hash = "sha256-4podJ3InBnNc+t4BpCQrg2QbJ9ZJr5fmroXyzo7JrZw=";
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

  meta = {
    description = "Rewritten version of MCDaemon, a python tool to control your Minecraft server";
    homepage = "https://mcdreforged.com";
    changelog = "https://github.com/MCDReforged/MCDReforged/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mcdreforged";
  };
}
