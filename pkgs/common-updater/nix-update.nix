{ nix-update }:

{ attrPath }:

[ "${nix-update}/bin/nix-update" attrPath ]
