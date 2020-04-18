{ runCommand, lib, }:

LuaPathSearchPaths: LuaCPathSearchPaths:

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
''
