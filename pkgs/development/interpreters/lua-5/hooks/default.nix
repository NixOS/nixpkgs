# Hooks for building lua packages.
{
  lua,
  makeSetupHook,
}:

let
  callPackage = lua.pkgs.callPackage;
in
{
  /**
    Accepts "bustedFlags" as an array.
    You can customize the call by setting "bustedFlags" and prevent the test from running by setting "dontBustedCheck"
  */
  bustedCheckHook = callPackage (
    { busted }:
    makeSetupHook {
      name = "busted-check-hook";
      propagatedBuildInputs = [
        busted
      ];
    } ./busted-check-hook.sh
  ) { };

  luarocksCheckHook = callPackage (
    { luarocks }:
    makeSetupHook {
      name = "luarocks-check-hook";
      propagatedBuildInputs = [ luarocks ];
    } ./luarocks-check-hook.sh
  ) { };

  # luarocks installs data in a non-overridable location. Until a proper luarocks patch,
  # we move the files around ourselves
  luarocksMoveDataFolder = makeSetupHook {
    name = "luarocks-move-rock";
    propagatedBuildInputs = [ ];
  } ./luarocks-move-data.sh;
}
