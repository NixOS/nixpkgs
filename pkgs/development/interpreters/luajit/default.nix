{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, version
, src
, extraMeta ? { }
, callPackage
, self
, packageOverrides ? (final: prev: {})
, pkgsBuildBuild
, pkgsBuildHost
, pkgsBuildTarget
, pkgsHostHost
, pkgsTargetTarget
, passthruFun
, enableFFI ? true
, enableJIT ? true
, enableJITDebugModule ? enableJIT
, enableGC64 ? true
, enable52Compat ? false
, enableValgrindSupport ? false
, valgrind ? null
, enableGDBJITSupport ? false
, enableAPICheck ? false
, enableVMAssertions ? false
, enableRegisterAllocationRandomization ? false
, useSystemMalloc ? false
# Upstream generates randomized string id's by default for security reasons
# https://github.com/LuaJIT/LuaJIT/issues/626. Deterministic string id's should
# never be needed for correctness (that should be fixed in the lua code),
# but may be helpful when you want to embed jit-compiled raw lua blobs in
# binaries that you want to be reproducible.
, deterministicStringIds ? false
, luaAttr ? "luajit_${lib.versions.major version}_${lib.versions.minor version}"
} @ inputs:
assert enableJITDebugModule -> enableJIT;
assert enableGDBJITSupport -> enableJIT;
assert enableValgrindSupport -> valgrind != null;
let

  luaPackages = self.pkgs;

  XCFLAGS = with lib;
    optional (!enableFFI) "-DLUAJIT_DISABLE_FFI"
    ++ optional (!enableJIT) "-DLUAJIT_DISABLE_JIT"
    ++ optional enable52Compat "-DLUAJIT_ENABLE_LUA52COMPAT"
    ++ optional (!enableGC64) "-DLUAJIT_DISABLE_GC64"
    ++ optional useSystemMalloc "-DLUAJIT_USE_SYSMALLOC"
    ++ optional enableValgrindSupport "-DLUAJIT_USE_VALGRIND"
    ++ optional enableGDBJITSupport "-DLUAJIT_USE_GDBJIT"
    ++ optional enableAPICheck "-DLUAJIT_USE_APICHECK"
    ++ optional enableVMAssertions "-DLUAJIT_USE_ASSERT"
    ++ optional enableRegisterAllocationRandomization "-DLUAJIT_RANDOM_RA"
    ++ optional deterministicStringIds "-DLUAJIT_SECURITY_STRID=0"
  ;

  # LuaJIT requires build for 32bit architectures to be build on x86 not x86_64
  # TODO support also other build architectures. The ideal way would be to use
  # stdenv_32bit but that doesn't work due to host platform mismatch:
  # https://github.com/NixOS/nixpkgs/issues/212494
  buildStdenv = if buildPackages.stdenv.isx86_64 && stdenv.is32bit
    then buildPackages.pkgsi686Linux.buildPackages.stdenv
    else buildPackages.stdenv;

in
stdenv.mkDerivation rec {
  pname = "luajit";
  inherit version src;

  luaversion = "5.1";

  postPatch = ''
    substituteInPlace Makefile --replace ldconfig :
    if test -n "''${dontStrip-}"; then
      # CCDEBUG must be non-empty or everything will be stripped, -g being
      # passed by nixpkgs CC wrapper is insufficient on its own
      substituteInPlace src/Makefile --replace "#CCDEBUG= -g" "CCDEBUG= -g"
    fi

    {
      echo -e '
        #undef  LUA_PATH_DEFAULT
        #define LUA_PATH_DEFAULT "./share/lua/${luaversion}/?.lua;./?.lua;./?/init.lua"
        #undef  LUA_CPATH_DEFAULT
        #define LUA_CPATH_DEFAULT "./lib/lua/${luaversion}/?.so;./?.so;./lib/lua/${luaversion}/loadall.so"
      '
    } >> src/luaconf.h
  '';

  dontConfigure = true;

  buildInputs = lib.optional enableValgrindSupport valgrind;

  buildFlags = [
    "amalg" # Build highly optimized version
  ];
  makeFlags = [
    "PREFIX=$(out)"
    "DEFAULT_CC=cc"
    "CROSS=${stdenv.cc.targetPrefix}"
    "HOST_CC=${buildStdenv.cc}/bin/cc"
  ] ++ lib.optional enableJITDebugModule "INSTALL_LJLIBD=$(INSTALL_LMOD)"
    ++ lib.optional stdenv.hostPlatform.isStatic "BUILDMODE=static";
  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = toString XCFLAGS;

  postInstall = ''
    ( cd "$out/include"; ln -s luajit-*/* . )
    ln -s "$out"/bin/luajit-* "$out"/bin/lua
    if [[ ! -e "$out"/bin/luajit ]]; then
      ln -s "$out"/bin/luajit* "$out"/bin/luajit
    fi
  '';

  LuaPathSearchPaths    = luaPackages.luaLib.luaPathList;
  LuaCPathSearchPaths   = luaPackages.luaLib.luaCPathList;

  setupHook = luaPackages.lua-setup-hook luaPackages.luaLib.luaPathList luaPackages.luaLib.luaCPathList;

  # copied from python
  passthru = let
    # When we override the interpreter we also need to override the spliced versions of the interpreter
    inputs' = lib.filterAttrs (n: v: ! lib.isDerivation v && n != "passthruFun") inputs;
    override = attr: let lua = attr.override (inputs' // { self = lua; }); in lua;
  in passthruFun rec {
    inherit self luaversion packageOverrides luaAttr;
    executable = "lua";
    luaOnBuildForBuild = override pkgsBuildBuild.${luaAttr};
    luaOnBuildForHost = override pkgsBuildHost.${luaAttr};
    luaOnBuildForTarget = override pkgsBuildTarget.${luaAttr};
    luaOnHostForHost = override pkgsHostHost.${luaAttr};
    luaOnTargetForTarget = lib.optionalAttrs (lib.hasAttr luaAttr pkgsTargetTarget) (override pkgsTargetTarget.${luaAttr});
  };

  meta = with lib; {
    description = "High-performance JIT compiler for Lua 5.1";
    homepage = "https://luajit.org/";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    badPlatforms = [
      "riscv64-linux" "riscv64-linux" # See https://github.com/LuaJIT/LuaJIT/issues/628
      "powerpc64le-linux"             # `#error "No support for PPC64"`
    ];
    maintainers = with maintainers; [ thoughtpolice smironov vcunat lblasc ];
  } // extraMeta;
}
