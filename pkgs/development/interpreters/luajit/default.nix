{ lib
, stdenv
, buildPackages
, version
, src
, substituteAll
, extraMeta ? { }
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

  XCFLAGS =
    lib.optional (!enableFFI) "-DLUAJIT_DISABLE_FFI"
    ++ lib.optional (!enableJIT) "-DLUAJIT_DISABLE_JIT"
    ++ lib.optional enable52Compat "-DLUAJIT_ENABLE_LUA52COMPAT"
    ++ lib.optional (!enableGC64) "-DLUAJIT_DISABLE_GC64"
    ++ lib.optional useSystemMalloc "-DLUAJIT_USE_SYSMALLOC"
    ++ lib.optional enableValgrindSupport "-DLUAJIT_USE_VALGRIND"
    ++ lib.optional enableGDBJITSupport "-DLUAJIT_USE_GDBJIT"
    ++ lib.optional enableAPICheck "-DLUAJIT_USE_APICHECK"
    ++ lib.optional enableVMAssertions "-DLUAJIT_USE_ASSERT"
    ++ lib.optional enableRegisterAllocationRandomization "-DLUAJIT_RANDOM_RA"
    ++ lib.optional deterministicStringIds "-DLUAJIT_SECURITY_STRID=0"
  ;

  # LuaJIT requires build for 32bit architectures to be build on x86 not x86_64
  # TODO support also other build architectures. The ideal way would be to use
  # stdenv_32bit but that doesn't work due to host platform mismatch:
  # https://github.com/NixOS/nixpkgs/issues/212494
  buildStdenv = if buildPackages.stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.is32bit
    then buildPackages.pkgsi686Linux.buildPackages.stdenv
    else buildPackages.stdenv;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "luajit";
  inherit version src;

  luaversion = "5.1";

  postPatch = ''
    substituteInPlace Makefile --replace ldconfig :
    if test -n "''${dontStrip-}"; then
      # CCDEBUG must be non-empty or everything will be stripped, -g being
      # passed by nixpkgs CC wrapper is insufficient on its own
      substituteInPlace src/Makefile --replace-fail "#CCDEBUG= -g" "CCDEBUG= -g"
    fi
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
    mkdir -p $out/nix-support
    cp ${substituteAll {
      src = ../lua-5/utils.sh;
      luapathsearchpaths=lib.escapeShellArgs finalAttrs.LuaPathSearchPaths;
      luacpathsearchpaths=lib.escapeShellArgs finalAttrs.LuaCPathSearchPaths;
    }} $out/nix-support/utils.sh
    ( cd "$out/include"; ln -s luajit-*/* . )
    ln -s "$out"/bin/luajit-* "$out"/bin/lua
    if [[ ! -e "$out"/bin/luajit ]]; then
      ln -s "$out"/bin/luajit* "$out"/bin/luajit
    fi
  '';

  LuaPathSearchPaths    = luaPackages.luaLib.luaPathList;
  LuaCPathSearchPaths   = luaPackages.luaLib.luaCPathList;

  setupHook = builtins.toFile "lua-setup-hook" ''
      source @out@/nix-support/utils.sh
      addEnvHooks "$hostOffset" luaEnvHook
      '';

  # copied from python
  passthru = let
    # When we override the interpreter we also need to override the spliced versions of the interpreter
    inputs' = lib.filterAttrs (n: v: ! lib.isDerivation v && n != "passthruFun") inputs;
    override = attr: let lua = attr.override (inputs' // { self = lua; }); in lua;
  in passthruFun rec {
    inherit self packageOverrides luaAttr;
    inherit (finalAttrs) luaversion;
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
})
