{
  lib,
  vscode-extensions-update,
}:

{
  attrPath ? null,
  extraArgs ? [ ],
}:

[ "${lib.getExe vscode-extensions-update}" ]
++ lib.optionals (attrPath != null) [ attrPath ]
++ extraArgs
