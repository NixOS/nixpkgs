{ stdenv, fetchurl, readline, compat ? false
, hostPlatform
, makeWrapper
, lua-setup-hook, callPackage
, self
, getLuaPath, getLuaCPath
, luaPackages, packageOverrides ? (self: super: {})
}:

stdenv.mkDerivation rec {
  name = "lua-${version}";
  majorVersion = "5.3";
  version = "${majorVersion}.4";

  # helper functions for dealing with LUA_PATH and LUA_CPATH
  LuaPathSearchPaths    = getLuaPath majorVersion;
  LuaCPathSearchPaths   = getLuaCPath majorVersion;
  setupHook = lua-setup-hook LuaPathSearchPaths LuaCPathSearchPaths;


  src = fetchurl {
    url = "https://www.lua.org/ftp/${name}.tar.gz";
    sha256 = "0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac";
  };

  buildInputs = [ readline ];

  patches = if stdenv.isDarwin then [ ./5.2.darwin.patch ] else [];

  configurePhase =
    if stdenv.isDarwin
    then ''
    makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=macosx CFLAGS="-DLUA_USE_LINUX -fno-common -O2 -fPIC${if compat then " -DLUA_COMPAT_ALL" else ""}" LDFLAGS="-fPIC" V=${majorVersion} R=${version} CC="$CC")
    installFlagsArray=( TO_BIN="lua luac" TO_LIB="liblua.${version}.dylib" INSTALL_DATA='cp -d' )
  '' else ''
    makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=linux CFLAGS="-DLUA_USE_LINUX -O2 -fPIC${if compat then " -DLUA_COMPAT_ALL" else ""}" LDFLAGS="-fPIC" V=${majorVersion} R=${version} CC="$CC" AR="$AR q" RANLIB="$RANLIB")
    installFlagsArray=( TO_BIN="lua luac" TO_LIB="liblua.a liblua.so liblua.so.${majorVersion} liblua.so.${version}" INSTALL_DATA='cp -d' )
    cat ${./lua-5.3-dso.make} >> src/Makefile
    sed -e 's/ALL_T *= */& $(LUA_SO)/' -i src/Makefile
  '';

  postBuild = stdenv.lib.optionalString (! stdenv.isDarwin) ''
    ( cd src; make liblua.so "''${makeFlagsArray[@]}" )
  '';

  postInstall = ''
    mkdir -p "$out/share/doc/lua" "$out/lib/pkgconfig"
    mv "doc/"*.{gif,png,css,html} "$out/share/doc/lua/"
    rmdir $out/{share,lib}/lua/${majorVersion} $out/{share,lib}/lua
    mkdir -p "$out/lib/pkgconfig"
    cat >"$out/lib/pkgconfig/lua.pc" <<EOF
    prefix=$out
    libdir=$out/lib
    includedir=$out/include
    INSTALL_BIN=$out/bin
    INSTALL_INC=$out/include
    INSTALL_LIB=$out/lib
    INSTALL_MAN=$out/man/man1

    Name: Lua
    Description: An Extensible Extension Language
    Version: ${version}
    Requires:
    Libs: -L$out/lib -llua -lm
    Cflags: -I$out/include
    EOF
    ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua${luaversion}.pc"
  '';

  passthru = let
    luaPackages = callPackage ../../../top-level/lua-packages.nix {lua=self; overrides=packageOverrides;};
  in rec {
    # executable = "${libPrefix}m";
    buildEnv = callPackage ./wrapper.nix { lua = self;
    inherit (luaPackages) requiredLuaModules;
    };
    withPackages = import ./with-packages.nix { inherit buildEnv luaPackages;};
    pkgs = luaPackages;
    interpreter = "${self}/bin/lua";
  };

  meta = {
    homepage = http://www.lua.org;
    description = "Powerful, fast, lightweight, embeddable scripting language";
    longDescription = ''
      Lua combines simple procedural syntax with powerful data
      description constructs based on associative arrays and extensible
      semantics. Lua is dynamically typed, runs by interpreting bytecode
      for a register-based virtual machine, and has automatic memory
      management with incremental garbage collection, making it ideal
      for configuration, scripting, and rapid prototyping.
    '';
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
