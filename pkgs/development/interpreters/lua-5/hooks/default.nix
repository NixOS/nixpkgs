# Hooks for building lua packages.
{ lua
, lib
, makeSetupHook
, findutils
, runCommand
}:

let
  callPackage = lua.pkgs.callPackage;
  luaInterpreter = lua.interpreter;
in {

  lua-setup-hook = LuaPathSearchPaths: LuaCPathSearchPaths:
    let
      hook = ./setup-hook.sh;
    in runCommand "lua-setup-hook.sh" {
      # hum doesn't seem to like caps !! BUG ?
      luapathsearchpaths=lib.escapeShellArgs LuaPathSearchPaths;
      luacpathsearchpaths=lib.escapeShellArgs LuaCPathSearchPaths;
    } ''
      cp ${hook} hook.sh
      substituteAllInPlace hook.sh
      mv hook.sh $out
    '';

  luarocksCheckHook = callPackage ({ luarocks }:
    makeSetupHook {
      name = "luarocks-check-hook";
      deps = [ luarocks ];
    } ./luarocks-check-hook.sh) {};

  # luarocks installs data in a non-overridable location. Until a proper luarocks patch,
  # we move the files around ourselves
  luarocksMoveDataFolder = callPackage ({ }:
    makeSetupHook {
      name = "luarocks-move-rock";
      deps = [ ];
    } ./luarocks-move-data.sh) {};
}
