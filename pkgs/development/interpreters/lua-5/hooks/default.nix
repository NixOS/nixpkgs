# Hooks for building lua packages.
{ lua
, lib
, makeSetupHook
, runCommand
}:

let
  callPackage = lua.pkgs.callPackage;
in {

  luarocksCheckHook = callPackage ({ luarocks }:
    makeSetupHook {
      name = "luarocks-check-hook";
      propagatedBuildInputs = [ luarocks ];
    } ./luarocks-check-hook.sh) {};

  # luarocks installs data in a non-overridable location. Until a proper luarocks patch,
  # we move the files around ourselves
  luarocksMoveDataFolder = callPackage ({ }:
    makeSetupHook {
      name = "luarocks-move-rock";
      propagatedBuildInputs = [ ];
    } ./luarocks-move-data.sh) {};
}
