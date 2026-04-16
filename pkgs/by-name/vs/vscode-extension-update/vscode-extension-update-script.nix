{
  lib,
  vscode-extension-update,
}:

{
  attrPath ? null,
  extraArgs ? [ ],
}:

[ "${vscode-extension-update.exe}" ] ++ lib.optionals (attrPath != null) [ attrPath ] ++ extraArgs
