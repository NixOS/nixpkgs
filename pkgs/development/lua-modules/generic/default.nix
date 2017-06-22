{ lua, writeText }:

{ buildInputs ? [], disabled ? false, ... } @ attrs:

if disabled then
  throw "${attrs.name} not supported by interpreter lua-${lua.luaversion}"
else
  lua.stdenv.mkDerivation ({
    preBuild = ''
      makeFlagsArray=(
        PREFIX=$out
        LUA_LIBDIR="$out/lib/lua/${lua.luaversion}"
        LUA_INC="-I${lua}/include");
    '';
  } //
  attrs // {
    name = "lua${lua.luaversion}-" + attrs.name;
    buildInputs = buildInputs ++ [ lua ];

    # The function addToSearchPathWithCustomDelimiter breaks with ";" in
    # the search path.
    setupHook = writeText "setup-hook.sh" ''
      addLuaPath() {
        if [[ -d "$1/lib/lua/${lua.luaversion}" ]]; then
          LUA_PATH="$1/lib/lua/${lua.luaversion}/?.lua;$LUA_PATH"
          LUA_CPATH="$1/lib/lua/${lua.luaversion}/?.so;$LUA_CPATH"
        fi
        if [[ -d "$1/share/lua/${lua.luaversion}" ]]; then
          LUA_PATH="$1/share/lua/${lua.luaversion}/?.lua;$LUA_PATH"
          LUA_CPATH="$1/share/lua/${lua.luaversion}/?.so;$LUA_CPATH"
        fi
        export LUA_PATH
        export LUA_CPATH
      }
      envHooks+=(addLuaPath)
    '';
  })
