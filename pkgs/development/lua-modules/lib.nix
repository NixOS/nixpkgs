{ pkgs, lib, lua }:
let
  requiredLuaModules = drvs: with lib; let
    modules =  filter hasLuaModule drvs;
  in unique ([lua] ++ modules ++ concatLists (catAttrs "requiredLuaModules" modules));
  # Check whether a derivation provides a lua module.
  hasLuaModule = drv: drv ? luaModule;
in
rec {
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
    drv.overrideAttrs( oldAttrs: {
      # Use passthru in order to prevent rebuilds when possible.
      passthru = (oldAttrs.passthru or {}) // {
        luaModule = lua;
        requiredLuaModules = requiredLuaModules drv.propagatedBuildInputs;
      };
    });
}
