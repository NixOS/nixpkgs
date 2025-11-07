{
  lib,
  vscode-extension-update,
}:

{
  attrPath ? null,
  extraArgs ? [ ],
}:

[ "${lib.getExe vscode-extension-update}" ]
++ lib.optionals (attrPath != null) [ attrPath ]
++ extraArgs
