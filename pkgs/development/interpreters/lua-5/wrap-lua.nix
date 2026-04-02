{
  lua,
  makeSetupHook,
  makeWrapper,
}:

# defined in trivial-builders
# imported as wrapLua in lua-packages.nix and passed to build-lua-derivation to be used as buildInput
makeSetupHook {
  name = "wrap-lua-hook";
  propagatedBuildInputs = [ makeWrapper ];
  substitutions.luaBuild = lua.luaOnBuildForHost;
  substitutions.luaHost = lua.luaOnHostForHost;
  substitutions.luarocksBuild = lua.luaOnBuildForHost.pkgs.luarocks_bootstrap;
  substitutions.luarocksHost = lua.luaOnHostForHost.pkgs.luarocks_bootstrap;
} ./wrap.sh
