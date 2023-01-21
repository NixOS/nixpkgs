{ lib
, lua
, makeSetupHook
, makeWrapper
}:

# defined in trivial-builders.nix
# imported as wrapLua in lua-packages.nix and passed to build-lua-derivation to be used as buildInput
makeSetupHook {
  name = "wrap-lua-hook";
  deps = makeWrapper;
  substitutions.executable = lua.interpreter;
  substitutions.lua = lua;
  substitutions.LuaPathSearchPaths = lib.escapeShellArgs lua.LuaPathSearchPaths;
  substitutions.LuaCPathSearchPaths = lib.escapeShellArgs lua.LuaPathSearchPaths;
} ./wrap.sh
