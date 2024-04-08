{ pkgs, lib, lua }:
let
  inherit (lib.generators) toLua;
  requiredLuaModules = drvs: with lib; let
    modules =  filter hasLuaModule drvs;
  in unique ([lua] ++ modules ++ concatLists (catAttrs "requiredLuaModules" modules));
  # Check whether a derivation provides a lua module.
  hasLuaModule = drv: drv ? luaModule;


  /*
  Use this to override the arguments passed to buildLuarocksPackage
  */
  overrideLuarocks = drv: f: (drv.override (args: args // {
    buildLuarocksPackage = drv: (args.buildLuarocksPackage drv).override f;
  })) // {
    overrideScope = scope: overrideLuarocks (drv.overrideScope scope) f;
  };

in
rec {
  inherit overrideLuarocks;
  inherit hasLuaModule requiredLuaModules;

  luaPathList = [
    "share/lua/${lua.luaversion}/?.lua"
    "share/lua/${lua.luaversion}/?/init.lua"
  ];
  luaCPathList = [
    "lib/lua/${lua.luaversion}/?.so"
  ];

  /* generate paths without a prefix
  */
  luaPathRelStr = lib.concatStringsSep ";" luaPathList;
  luaCPathRelStr = lib.concatStringsSep ";" luaCPathList;

  /* generate LUA_(C)PATH value for a specific derivation, i.e., with absolute paths
  */
  genLuaPathAbsStr = drv: lib.concatMapStringsSep ";" (x: "${drv}/${x}") luaPathList;
  genLuaCPathAbsStr = drv: lib.concatMapStringsSep ";" (x: "${drv}/${x}") luaCPathList;

  /* Generate a LUA_PATH with absolute paths
  */
  # genLuaPathAbs = drv:
  #   lib.concatStringsSep ";" (map (x: "${drv}/x") luaPathList);

  luaAtLeast = lib.versionAtLeast lua.luaversion;
  luaOlder = lib.versionOlder lua.luaversion;
  isLua51 = (lib.versions.majorMinor lua.version) == "5.1";
  isLua52 = (lib.versions.majorMinor lua.version) == "5.2";
  isLua53 = lua.luaversion == "5.3";
  isLuaJIT = lib.getName lua == "luajit";

  /* generates the relative path towards the folder where
   seems stable even when using  lua_modules_path = ""

   Example:
    getDataFolder luaPackages.stdlib
    => stdlib-41.2.2-1-rocks/stdlib/41.2.2-1/doc
  */
  getDataFolder = drv:
    "${drv.pname}-${drv.version}-rocks/${drv.pname}/${drv.version}";

  /* Convert derivation to a lua module.
    so that luaRequireModules can be run later
  */
  toLuaModule = drv:
    drv.overrideAttrs(oldAttrs: {
      # Use passthru in order to prevent rebuilds when possible.
      passthru = (oldAttrs.passthru or {}) // {
        luaModule = lua;
        requiredLuaModules = requiredLuaModules drv.propagatedBuildInputs;
      };
    });


  /* generate a luarocks config conforming to:
    https://github.com/luarocks/luarocks/wiki/Config-file-format

    The config lists folders where to find lua dependencies

    Example:
      generateLuarocksConfig {
        externalDeps = [ { name = "CRYPTO"; dep = pkgs.openssl; } ];
        rocksSubdir = "subdir";
      };

    Type:
       generateLuarocksConfig :: AttrSet -> String
  */
  generateLuarocksConfig = {
      externalDeps ? []
    # a list of lua derivations
    , requiredLuaRocks ? []
    , rocksSubdir ? "rocks-subdir"
    , ...
    }@args: let
      rocksTrees = lib.imap0
        (i: dep: {
          name = "dep-${toString i}";
          root = "${dep}";
          # packages built by buildLuaPackage or luarocks doesn't contain rocksSubdir
          # hence a default here
          rocks_dir = if dep ? rocksSubdir then "${dep}/${dep.rocksSubdir}" else "${dep.pname}-${dep.version}-rocks";
        })
        requiredLuaRocks;

      # Explicitly point luarocks to the relevant locations for multiple-output
      # derivations that are external dependencies, to work around an issue it has
      # (https://github.com/luarocks/luarocks/issues/766)
      depVariables = zipAttrsWithLast (lib.lists.map ({name, dep}: {
        "${name}_INCDIR" = "${lib.getDev dep}/include";
        "${name}_LIBDIR" = "${lib.getLib dep}/lib";
        "${name}_BINDIR" = "${lib.getBin dep}/bin";
      }) externalDeps');
      zipAttrsWithLast = lib.attrsets.zipAttrsWith (name: lib.lists.last);

      # example externalDeps': [ { name = "CRYPTO"; dep = pkgs.openssl; } ]
      externalDeps' = lib.filter (dep: !lib.isDerivation dep) externalDeps;

      externalDepsDirs = map
        (x: builtins.toString x)
        (lib.filter (lib.isDerivation) externalDeps);

      generatedConfig = ({
        local_cache = "";

        # To prevent collisions when creating environments, we install the rock
        # files into per-package subdirectories
        rocks_subdir = rocksSubdir;

        # first tree is the default target where new rocks are installed,
        # any other trees in the list are treated as additional sources of installed rocks for matching dependencies.
        rocks_trees = (
          [{name = "current"; root = "${placeholder "out"}"; rocks_dir = "current"; }] ++
          rocksTrees
        );
      } // lib.optionalAttrs lua.pkgs.isLuaJIT {
        # Luajit provides some additional functionality built-in; this exposes
        # that to luarock's dependency system
        rocks_provided = {
          jit = "${lua.luaversion}-1";
          ffi = "${lua.luaversion}-1";
          luaffi = "${lua.luaversion}-1";
          bit = "${lua.luaversion}-1";
        };
      } // {
        # For single-output external dependencies
        external_deps_dirs = externalDepsDirs;
        # Some needed machinery to handle multiple-output external dependencies,
        # as per https://github.com/luarocks/luarocks/issues/766
        variables = depVariables;
      }
      // removeAttrs args [ "requiredLuaRocks" "externalDeps" ]
      );
  in generatedConfig;
}
