{ stdenv, fetchurl, readline
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

  # see configurePhase for additional flags (with space)
  makeFlags = [
    "INSTALL_TOP=${placeholder "out"}"
    "INSTALL_MAN=${placeholder "out"}/share/man/man1"
    "R=${version}"
    "LDFLAGS=-fPIC"
    "V=${luaversion}"
  ] ++ (if stdenv.isDarwin then [
    "PLAT=macosx"
  ] else [
    "PLAT=linux"
  ]) ++ (if stdenv.buildPlatform != stdenv.hostPlatform then [
    "CC=${stdenv.hostPlatform.config}-gcc"
    "RANLIB=${stdenv.hostPlatform.config}-ranlib"
  ] else [])
  ;

  configurePhase = ''
    runHook preConfigure

    makeFlagsArray+=(CFLAGS="-DLUA_USE_LINUX -O2 -fPIC${if compat then " -DLUA_COMPAT_ALL" else ""}" )
    makeFlagsArray+=(${stdenv.lib.optionalString stdenv.isDarwin "CC=\"$CC\""}${stdenv.lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) " 'AR=${stdenv.hostPlatform.config}-ar rcu'"})

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
    Libs: -L$out/lib -llua -lm
    Cflags: -I$out/include
    EOF
    ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua${luaversion}.pc"
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
};
in self
