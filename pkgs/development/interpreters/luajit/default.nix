{ stdenv, fetchurl, buildPackages
, name ? "luajit-${version}"
, isStable
, sha256
, version
, extraMeta ? {}
, callPackage
, self
, packageOverrides ? (self: super: {})
, enableFFI ? true
, enableJIT ? true
, enableJITDebugModule ? enableJIT
, enable52Compat ? false
, enableValgrindSupport ? false
, valgrind ? null
, enableGDBJITSupport ? false
, enableAPICheck ? false
, enableVMAssertions ? false
, useSystemMalloc ? false
}:
assert enableJITDebugModule -> enableJIT;
assert enableGDBJITSupport -> enableJIT;
assert enableValgrindSupport -> valgrind != null;
let
  luaPackages = callPackage ../../lua-modules {lua=self; overrides=packageOverrides;};

  XCFLAGS = with stdenv.lib;
     optional (!enableFFI) "-DLUAJIT_DISABLE_FFI"
  ++ optional (!enableJIT) "-DLUAJIT_DISABLE_JIT"
  ++ optional enable52Compat "-DLUAJIT_ENABLE_LUA52COMPAT"
  ++ optional useSystemMalloc "-DLUAJIT_USE_SYSMALLOC"
  ++ optional enableValgrindSupport "-DLUAJIT_USE_VALGRIND"
  ++ optional enableGDBJITSupport "-DLUAJIT_USE_GDBJIT"
  ++ optional enableAPICheck "-DLUAJIT_USE_APICHECK"
  ++ optional enableVMAssertions "-DLUAJIT_USE_ASSERT"
  ;
in
stdenv.mkDerivation rec {
  inherit name version;
  src = fetchurl {
    url = "http://luajit.org/download/LuaJIT-${version}.tar.gz";
    inherit sha256;
  };

  luaversion = "5.1";

  postPatch = ''
    substituteInPlace Makefile --replace ldconfig :
    if test -n "''${dontStrip-}"; then
      # CCDEBUG must be non-empty or everything will be stripped, -g being
      # passed by nixpkgs CC wrapper is insufficient on its own
      substituteInPlace src/Makefile --replace "#CCDEBUG= -g" "CCDEBUG= -g"
    fi
  '';

  configurePhase = false;

  buildInputs = stdenv.lib.optional enableValgrindSupport valgrind;

  buildFlags = [
    "amalg" # Build highly optimized version
  ];
  makeFlags = [
    "PREFIX=$(out)"
    "DEFAULT_CC=cc"
    "CROSS=${stdenv.cc.targetPrefix}"
    # TODO: when pointer size differs, we would need e.g. -m32
    "HOST_CC=${buildPackages.stdenv.cc}/bin/cc"
  ] ++ stdenv.lib.optional enableJITDebugModule "INSTALL_LJLIBD=$(INSTALL_LMOD)";
  enableParallelBuilding = true;
  NIX_CFLAGS_COMPILE = XCFLAGS;

  postInstall = ''
    ( cd "$out/include"; ln -s luajit-*/* . )
    ln -s "$out"/bin/luajit-* "$out"/bin/lua
  '' + stdenv.lib.optionalString (!isStable) ''
    ln -s "$out"/bin/luajit-* "$out"/bin/luajit
  '';

  LuaPathSearchPaths = [
    "lib/lua/${luaversion}/?.lua" "share/lua/${luaversion}/?.lua"
    "share/lua/${luaversion}/?/init.lua" "lib/lua/${luaversion}/?/init.lua"
    "share/${name}/?.lua"
  ];
  LuaCPathSearchPaths = [ "lib/lua/${luaversion}/?.so" "share/lua/${luaversion}/?.so" ];
  setupHook = luaPackages.lua-setup-hook LuaPathSearchPaths LuaCPathSearchPaths;

  passthru = rec {
    buildEnv = callPackage ../lua-5/wrapper.nix {
      lua = self;
      inherit (luaPackages) requiredLuaModules;
    };
    withPackages = import ../lua-5/with-packages.nix { inherit buildEnv luaPackages;};
    pkgs = luaPackages;
    interpreter = "${self}/bin/lua";
  };

  meta = with stdenv.lib; {
    description = "High-performance JIT compiler for Lua 5.1";
    homepage    = http://luajit.org;
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ thoughtpolice smironov vcunat andir ];
  } // extraMeta;
}
