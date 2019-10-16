{ stdenv, fetchurl, buildPackages
, name ? "luajit-${version}"
, isStable
, sha256
, version
, extraMeta ? {}
, callPackage
, self
, packageOverrides ? (self: super: {})
}:
let
  luaPackages = callPackage ../../lua-modules {lua=self; overrides=packageOverrides;};
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
  '';

  configurePhase = false;

  makeFlags = [
    "PREFIX=$(out)"
    "DEFAULT_CC=cc"
    "CROSS=${stdenv.cc.targetPrefix}"
    # TODO: when pointer size differs, we would need e.g. -m32
    "HOST_CC=${buildPackages.stdenv.cc}/bin/cc"
  ];
  buildFlags = [ "amalg" ]; # Build highly optimized version
  enableParallelBuilding = true;

  postInstall = ''
      ( cd "$out/include"; ln -s luajit-*/* . )
      ln -s "$out"/bin/luajit-* "$out"/bin/lua
    ''
    + stdenv.lib.optionalString (!isStable) ''
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

