{ lib, stdenv, lua, buildEnv, makeWrapper
, extraLibs ? []
, extraOutputsToInstall ? []
, postBuild ? ""
, ignoreCollisions ? false
, requiredLuaModules
, makeWrapperArgs ? []
}:

# Create a lua executable that knows about additional packages.
let
  env = let
    paths = [ lua ] ++ requiredLuaModules extraLibs;
  in buildEnv {
    name = "${lua.name}-env";

    inherit paths;
    inherit ignoreCollisions;
    extraOutputsToInstall = [ "out" ] ++ extraOutputsToInstall;

    nativeBuildInputs = [
      makeWrapper
    ];

    # we create wrapper for the binaries in the different packages
    postBuild = ''
      source ${lua}/nix-support/utils.sh
      if [ -L "$out/bin" ]; then
          unlink "$out/bin"
      fi
      mkdir -p "$out/bin"

      addToLuaPath "$out"

      # take every binary from lua packages and put them into the env
      for path in ${lib.concatStringsSep " " paths}; do
        nix_debug "looking for binaries in path = $path"
        if [ -d "$path/bin" ]; then
          cd "$path/bin"
          for prg in *; do
            if [ -f "$prg" ]; then
              rm -f "$out/bin/$prg"
              if [ -x "$prg" ]; then
                nix_debug "Making wrapper $prg"
                makeWrapper "$path/bin/$prg" "$out/bin/$prg" \
                  --set-default LUA_PATH ";;" \
                  --suffix LUA_PATH ';' "$LUA_PATH" \
                  --set-default LUA_CPATH ";;" \
                  --suffix LUA_CPATH ';' "$LUA_CPATH" \
                  ${lib.concatStringsSep " " makeWrapperArgs}
              fi
            fi
          done
        fi
      done
    '' + postBuild;

    inherit (lua) meta;

    passthru = lua.passthru // {
      interpreter = "${env}/bin/lua";
      inherit lua;
      luaPath = lua.pkgs.luaLib.genLuaPathAbsStr env;
      luaCpath = lua.pkgs.luaLib.genLuaCPathAbsStr env;
      env = stdenv.mkDerivation {
        name = "interactive-${lua.name}-environment";
        nativeBuildInputs = [ env ];

        buildCommand = ''
          echo >&2 ""
          echo >&2 "*** lua 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
          echo >&2 ""
          exit 1
        '';
    };
    };
  };
in env
