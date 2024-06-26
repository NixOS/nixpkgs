{ lib, nix-update }:

{
  attrPath ? null,
  extraArgs ? [ ],
}:

[ "${lib.getExe nix-update}" ] ++ extraArgs ++ lib.optional (attrPath != null) attrPath
