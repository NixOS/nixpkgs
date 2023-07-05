pkgs: lib: self: super:

### Deprecated aliases - for backward compatibility
###
### !!! NOTE !!!
### Use `./remove-attr.py [attrname]` in this directory to remove your alias
### from the `nodePackages` set without regenerating the entire file.

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
    if alias.recurseForDerivations or false
    then removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib;
    if isDerivation alias then
      dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from node-packages.nix.
  checkInPkgs = n: alias:
    if builtins.hasAttr n super
    then throw "Alias ${n} is still in node-packages.nix"
    else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias:
      removeDistribute
        (removeRecurseForDerivations
          (checkInPkgs n alias)))
      aliases;
in

mapAliases {
  "@antora/cli" = pkgs.antora; # Added 2023-05-06
  "@githubnext/github-copilot-cli" = pkgs.github-copilot-cli; # Added 2023-05-02
  "@google/clasp" = pkgs.google-clasp; # Added 2023-05-07
  "@nestjs/cli" = pkgs.nest-cli; # Added 2023-05-06
  eslint_d = pkgs.eslint_d; # Added 2023-05-26
  manta = pkgs.node-manta; # Added 2023-05-06
  readability-cli = pkgs.readability-cli; # Added 2023-06-12
  thelounge = pkgs.thelounge; # Added 2023-05-22
  triton = pkgs.triton; # Added 2023-05-06
  typescript = pkgs.typescript; # Added 2023-06-21
  vscode-langservers-extracted = pkgs.vscode-langservers-extracted; # Added 2023-05-27
}
