lua:

{ buildInputs ? [], disabled ? false, ... } @ attrs:

if disabled then
  throw "${attrs.name} not supported by interpreter lua-${lua.luaversion}"
else
  lua.stdenv.mkDerivation (
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
      name = "lua${lua.luaversion}-" + attrs.name;
      buildInputs = buildInputs ++ [ lua ];
    }
  )
