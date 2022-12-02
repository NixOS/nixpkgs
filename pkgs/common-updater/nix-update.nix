{ nix-update }:

{ attrPath
, extraArgs ? []
}:

[ "${nix-update}/bin/nix-update" ] ++ extraArgs ++ [ attrPath ]
