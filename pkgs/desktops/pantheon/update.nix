{ nix-update }:

{ attrPath }:


# We're using nix-update https://github.com/Mic92/nix-update which can technically
# update way more than just pantheon.
[ "${nix-update}/bin/nix-update" attrPath ]
