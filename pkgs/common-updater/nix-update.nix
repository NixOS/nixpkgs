{ lib, nix-update }:

{ attrPath ? null
, extraArgs ? [ ]
}:

[ "${nix-update}/bin/nix-update" ] ++ extraArgs ++ lib.optional (attrPath != null) attrPath
