{ lua, writeText, toLuaModule }:

{ disabled ? false
, propagatedBuildInputs ? [ ]
, ...
} @ attrs:

if disabled then
  throw "${attrs.name} not supported by interpreter lua-${lua.luaversion}"
else
  toLuaModule (lua.stdenv.mkDerivation (
    {
      makeFlags = [
        "PREFIX=$(out)"
        "LUA_LIBDIR=$(out)/lib/lua/${lua.luaversion}"
        "LUA_INC=-I${lua}/include"
      ];
    }
    //
    attrs
    //
    {
      name = "lua${lua.luaversion}-" + attrs.pname + "-" + attrs.version;
      propagatedBuildInputs = propagatedBuildInputs ++ [
        lua # propagate it for its setup-hook
      ];
    }
  ))
