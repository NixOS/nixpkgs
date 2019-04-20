{ stdenv, fetchurl, readline
, compat ? false
, callPackage
# , self
# TODO remove ?
, packageOverrides ? (self: super: {})
, sourceVersion
# for noa sha256, then use SRI https://github.com/NixOS/nixpkgs/pull/59215#discussion_r274783187
, hash
, patches ? []
# , passthru
}:
let
luaPackages = callPackage ../../lua-modules {lua=self; overrides=packageOverrides;};

self = stdenv.mkDerivation rec {
  pname = "lua";
  luaversion = with sourceVersion; "${major}.${minor}";
  version = "${luaversion}.${sourceVersion.patch}";

  src = fetchurl {
    url = "https://www.lua.org/ftp/${pname}-${luaversion}.tar.gz";
    sha256 = hash;
  };

  LuaPathSearchPaths    = luaPackages.getLuaPathList luaversion;
  LuaCPathSearchPaths   = luaPackages.getLuaCPathList luaversion;
  setupHook = luaPackages.lua-setup-hook LuaPathSearchPaths LuaCPathSearchPaths;

  buildInputs = [ readline ];

  inherit patches;

  # installFlagsArray= [
  #   ''TO_BIN="lua luac"''
  #   ''INSTALL_DATA="cp -d"''
  # ] ++ (if stdenv.isDarwin then [
  #   ''TO_LIB="liblua.${version}.dylib"''
  # ] else [
  #     # from lua5.1
 # # TO_BIN="lua luac" TO_LIB="liblua.a liblua.so liblua.so.5.1 liblua.so.5.1.5" INSTALL_DATA='cp -d'
  #   ''TO_LIB="liblua.a liblua.so liblua.so.${luaversion} liblua.so.${version}"''
  # ]);

  makeFlags = [
    "INSTALL_TOP=${placeholder "out"}"
    "INSTALL_MAN=${placeholder "out"}/share/man/man1"
    "R=${version}"
    ''LDFLAGS="-fPIC"''
    "V=${luaversion}"
  ] ++ (if stdenv.isDarwin then [
    "PLAT=macosx"
    ''CC="$CC"''
  ] else [
    "PLAT=linux"
  ])
  ++ stdenv.lib.optional compat " -DLUA_COMPAT_ALL"
  ;

  # TODO for lua 5.3, add dso ?
  # cat ${./lua-5.3-dso.make} >> src/Makefile
  # TODO fix the cmakeFlags for darwin
  # TODO AR only for 5.1
  # AR="$AR q" RANLIB="$RANLIB"
  #
  configurePhase = ''
    runHook preConfigure

    echo "Current makeFlagsArray"
    echo "''${makeFlagsArray[@]}"
    makeFlagsArray+=(CFLAGS="-DLUA_USE_LINUX -O2 -fPIC${if compat then " -DLUA_COMPAT_ALL" else ""}" )

    installFlagsArray=( TO_BIN="lua luac" INSTALL_DATA='cp -d' \
      TO_LIB="${ if stdenv.isDarwin then "liblua.${version}.dylib" else "liblua.a liblua.so liblua.so.${luaversion} liblua.so.${version}"}" )

    runHook postConfigure
  '';

  # configurePhase =
  #   if stdenv.isDarwin
  #   then ''
  #   makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=macosx CFLAGS="-DLUA_USE_LINUX -fno-common -O2 -fPIC${if compat then " -DLUA_COMPAT_ALL" else ""}" LDFLAGS="-fPIC" V=${luaversion} R=${version}  CC="$CC" )
  #   installFlagsArray=( TO_BIN="lua luac" TO_LIB="liblua.${version}.dylib" INSTALL_DATA='cp -d' )
  # '' else ''
  #   makeFlagsArray=( INSTALL_TOP=$out INSTALL_MAN=$out/share/man/man1 PLAT=linux CFLAGS="-DLUA_USE_LINUX -O2 -fPIC${if compat then " -DLUA_COMPAT_ALL" else ""}" LDFLAGS="-fPIC" V=${luaversion} R=${version} CC="$CC" AR="$AR q" RANLIB="$RANLIB" )
  #   cat ${./lua-5.3-dso.make} >> src/Makefile
  #   sed -e 's/ALL_T *= */& $(LUA_SO)/' -i src/Makefile
  # '';

  # why is it escaped here ?!
# make liblua.so 'INSTALL_TOP=/nix/store/2cay7167vh4f3dk0kz8hdjsafz4b8w26-lua-5.3.5 INSTALL_MAN=/nix/store/2cay7167vh4f3dk0kz8hdjsafz4b8w26-lua-5.3.5/share/man/man1 R=5.3.5 LDFLAGS="-fPIC" V=5.3 PLAT=linux CFLAGS=-DLUA_USE_LINUX -O2 -fPIC'
  postBuild = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    set -x
    ( cd src; make liblua.so $makeFlags "''${makeFlagsArray[@]}" )
    set +x
  '';

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

  # inherit passthru;

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
