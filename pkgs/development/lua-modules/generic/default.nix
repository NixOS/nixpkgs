lua:

{ buildInputs ? [], disabled ? false, ... } @ attrs:

assert !disabled;

lua.stdenv.mkDerivation ({

    preBuild = ''
      makeFlagsArray=(
        PREFIX=$out
        LUA_LIBDIR="$out/lib/lua/${lua.luaversion}"
        LUA_INC="-I${lua}/include");
    '';
  }
  //
  attrs
  //
  {
    name = "lua${lua.luaversion}-" + attrs.name;
    buildInputs = buildInputs ++ [ lua ];
  }
)
