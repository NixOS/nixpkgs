{
  writeScriptBin,
}:

writeScriptBin "vscode-extension-update" (builtins.readFile ./vscode_extension_update.py)
