{ stdenv, lib, fetchurl
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

  patchPhase = ''
    substituteInPlace Makefile \
      --replace /usr/local "$out"

    substituteInPlace src/Makefile --replace gcc cc
  '' + stdenv.lib.optionalString (stdenv.cc.libc != null)
  ''
    substituteInPlace Makefile \
      --replace ldconfig ${stdenv.cc.libc.bin or stdenv.cc.libc}/bin/ldconfig
  '';

  configurePhase = false;

  buildFlags = [ "amalg" ]; # Build highly optimized version
  enableParallelBuilding = true;

  installPhase   = ''
      make install PREFIX="$out"
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

  meta = with stdenv.lib; extraMeta // {
    description = "High-performance JIT compiler for Lua 5.1";
    homepage    = http://luajit.org;
    license     = licenses.mit;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ thoughtpolice smironov vcunat andir ];
  };
}

