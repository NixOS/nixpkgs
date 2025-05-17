# Note: when updating to a new major version (for now), add an alias to
# pkgs/top-level/aliases.nix
{
  z3_4_15,
  ...
}@args:

z3_4_15.override args
