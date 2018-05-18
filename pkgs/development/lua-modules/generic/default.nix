{ lua, writeText }:

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

      setupHook = writeText "setup-hook.sh" ''
        # check for lua/clua modules and don't add duplicates

        addLuaLibPath() {
          local package_path="$1/share/lua/${lua.luaversion}"
          if [[ ! -d $package_path ]]; then return; fi
          if [[ $LUA_PATH = *"$package_path"* ]]; then return; fi

          if [[ -z $LUA_PATH ]]; then
            export LUA_PATH="$package_path/?.lua"
          else
            export LUA_PATH="$LUA_PATH;$package_path/?.lua"
          fi
        }

        addLuaLibCPath() {
          local package_cpath="$1/lib/lua/${lua.luaversion}"
          if [[ ! -d $package_cpath ]]; then return; fi
          if [[ $LUA_CPATH = *"$package_cpath"* ]]; then return; fi

          if [[ -z $LUA_CPATH ]]; then
            export LUA_CPATH="$package_cpath/?.so"
          else
            export LUA_CPATH="$LUA_CPATH;$package_cpath/?.so"
          fi
        }

        addEnvHooks "$hostOffset" addLuaLibPath
        addEnvHooks "$hostOffset" addLuaLibCPath
      '';
    }
  )
