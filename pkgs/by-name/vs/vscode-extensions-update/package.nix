{
  writeScriptBin,
}:

writeScriptBin "vscode-extensions-update" (builtins.readFile ./vscode_extensions_update.py)
