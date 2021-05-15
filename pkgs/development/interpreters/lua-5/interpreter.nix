{ lib, stdenv, fetchurl, readline
, compat ? false
, callPackage
, packageOverrides ? (self: super: {})
, sourceVersion
, hash
, patches ? []
, postConfigure ? null
, postBuild ? null
}:
let
luaPackages = callPackage ../../lua-modules {lua=self; overrides=packageOverrides;};

plat = if stdenv.isLinux then "linux"
       else if stdenv.isDarwin then "macosx"
       else if stdenv.hostPlatform.isMinGW then "mingw"
       else if stdenv.isFreeBSD then "freebsd"
       else if stdenv.isSunOS then "solaris"
       else if stdenv.hostPlatform.isBSD then "bsd"
       else if stdenv.hostPlatform.isUnix then "posix"
       else "generic";

self = stdenv.mkDerivation rec {
  pname = "lua";
  luaversion = with sourceVersion; "${major}.${minor}";
  version = "${luaversion}.${sourceVersion.patch}";

  src = fetchurl {
    url = "https://www.lua.org/ftp/${pname}-${version}.tar.gz";
    sha256 = hash;
  };

  LuaPathSearchPaths    = luaPackages.getLuaPathList luaversion;
  LuaCPathSearchPaths   = luaPackages.getLuaCPathList luaversion;
  setupHook = luaPackages.lua-setup-hook LuaPathSearchPaths LuaCPathSearchPaths;

  buildInputs = [ readline ];

  inherit patches;

  postPatch = lib.optionalString (!stdenv.isDarwin) ''
    # Add a target for a shared library to the Makefile.
    sed -e '1s/^/LUA_SO = liblua.so/' \
        -e 's/ALL_T *= */&$(LUA_SO) /' \
        -i src/Makefile
    cat ${./lua-dso.make} >> src/Makefile
  '';

  # see configurePhase for additional flags (with space)
  makeFlags = [
    "INSTALL_TOP=${placeholder "out"}"
    "INSTALL_MAN=${placeholder "out"}/share/man/man1"
    "R=${version}"
    "LDFLAGS=-fPIC"
    "V=${luaversion}"
    "PLAT=${plat}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
  ];

  configurePhase = ''
    runHook preConfigure

    makeFlagsArray+=(CFLAGS='-O2 -fPIC${lib.optionalString compat " -DLUA_COMPAT_ALL"} $(${
      if lib.versionAtLeast luaversion "5.2" then "SYSCFLAGS" else "MYCFLAGS"})' )
    makeFlagsArray+=(${lib.optionalString stdenv.isDarwin "CC=\"$CC\""}${lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) " 'AR=${stdenv.cc.targetPrefix}ar rcu'"})

    installFlagsArray=( TO_BIN="lua luac" INSTALL_DATA='cp -d' \
      TO_LIB="${if stdenv.isDarwin then "liblua.${version}.dylib" else "liblua.a liblua.so liblua.so.${luaversion} liblua.so.${version}"}" )

    runHook postConfigure
  '';
  inherit postConfigure;

  inherit postBuild;

  postInstall = ''
    mkdir -p "$out/share/doc/lua" "$out/lib/pkgconfig"
    mv "doc/"*.{gif,png,css,html} "$out/share/doc/lua/"
    rmdir $out/{share,lib}/lua/${luaversion} $out/{share,lib}/lua
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
    Libs: -L$out/lib -llua
    Cflags: -I$out/include
    EOF
    ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua-${luaversion}.pc"
    ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua${luaversion}.pc"
    ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua${lib.replaceStrings [ "." ] [ "" ] luaversion}.pc"
  '';

  passthru = rec {
    buildEnv = callPackage ./wrapper.nix {
      lua = self;
      inherit (luaPackages) requiredLuaModules;
    };
    withPackages = import ./with-packages.nix { inherit buildEnv luaPackages;};
    pkgs = luaPackages;
    interpreter = "${self}/bin/lua";
  };

  meta = {
    homepage = "http://www.lua.org";
    description = "Powerful, fast, lightweight, embeddable scripting language";
    longDescription = ''
      Lua combines simple procedural syntax with powerful data
      description constructs based on associative arrays and extensible
      semantics. Lua is dynamically typed, runs by interpreting bytecode
      for a register-based virtual machine, and has automatic memory
      management with incremental garbage collection, making it ideal
      for configuration, scripting, and rapid prototyping.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
};
in self
