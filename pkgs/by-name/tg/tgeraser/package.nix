{
  fetchFromGitHub,
  lib,
  python3Packages,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tgeraser";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "en9inerd";
    repo = "tgeraser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PpqkjXI4bH7paLIRQihAEXByZJPqbkTm52280GLCF/Y=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    docopt
    pyaes
    pyasn1
    rsa
    telethon
  ];

  pythonImportsCheck = [ "tgeraser" ];

  nativeCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "Tool to delete all your messages from Telegram";
    longDescription = ''
      TgEraser is a Python tool that allows you to delete all your messages from
      a chat, channel, or conversation on Telegram without requiring admin
      privileges.
    '';
    homepage = "https://github.com/en9inerd/tgeraser";
    changelog = "https://github.com/en9inerd/tgeraser/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "tgeraser";
  };
})
