{
  lib,
  stdenv,
  fetchurl,
  readline,
  compat ? false,
  makeWrapper,
  self,
  packageOverrides ? (final: prev: { }),
  substituteAll,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsBuildTarget,
  pkgsHostHost,
  pkgsTargetTarget,
  version,
  hash,
  passthruFun,
  patches ? [ ],
  postConfigure ? null,
  postBuild ? null,
  staticOnly ? stdenv.hostPlatform.isStatic,
  luaAttr ? "lua${lib.versions.major version}_${lib.versions.minor version}",
}@inputs:

stdenv.mkDerivation (
  finalAttrs:
  let
    luaPackages = self.pkgs;

    luaversion = lib.versions.majorMinor finalAttrs.version;

    plat =
      if (stdenv.isLinux && lib.versionOlder self.luaversion "5.4") then
        "linux"
      else if (stdenv.isLinux && lib.versionAtLeast self.luaversion "5.4") then
        "linux-readline"
      else if stdenv.isDarwin then
        "macosx"
      else if stdenv.hostPlatform.isMinGW then
        "mingw"
      else if stdenv.isFreeBSD then
        "freebsd"
      else if stdenv.isSunOS then
        "solaris"
      else if stdenv.hostPlatform.isBSD then
        "bsd"
      else if stdenv.hostPlatform.isUnix then
        "posix"
      else
        "generic";

    compatFlags =
      if (lib.versionOlder self.luaversion "5.3") then
        " -DLUA_COMPAT_ALL"
      else if (lib.versionOlder self.luaversion "5.4") then
        " -DLUA_COMPAT_5_1 -DLUA_COMPAT_5_2"
      else
        " -DLUA_COMPAT_5_3";
  in

  {
    pname = "lua";
    inherit version;
    outputs = [
      "out"
      "doc"
    ];

    src = fetchurl {
      url = "https://www.lua.org/ftp/lua-${finalAttrs.version}.tar.gz";
      sha256 = hash;
    };

    LuaPathSearchPaths = luaPackages.luaLib.luaPathList;
    LuaCPathSearchPaths = luaPackages.luaLib.luaCPathList;
    setupHook = builtins.toFile "lua-setup-hook" ''
      source @out@/nix-support/utils.sh
      addEnvHooks "$hostOffset" luaEnvHook
    '';

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ readline ];

    inherit patches;

    postPatch =
      ''
        sed -i "s@#define LUA_ROOT[[:space:]]*\"/usr/local/\"@#define LUA_ROOT  \"$out/\"@g" src/luaconf.h

        # abort if patching didn't work
        grep $out src/luaconf.h
      ''
      + lib.optionalString (!stdenv.isDarwin && !staticOnly) ''
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
      # Lua links with readline wich depends on ncurses. For some reason when
      # building pkgsStatic.lua it fails because symbols from ncurses are not
      # found. Adding ncurses here fixes the problem.
      "MYLIBS=-lncurses"
    ];

    configurePhase = ''
      runHook preConfigure

      makeFlagsArray+=(CFLAGS='-O2 -fPIC${lib.optionalString compat compatFlags} $(${
        if lib.versionAtLeast luaversion "5.2" then "SYSCFLAGS" else "MYCFLAGS"
      })' )
      makeFlagsArray+=(${lib.optionalString stdenv.isDarwin "CC=\"$CC\""}${
        lib.optionalString (
          stdenv.buildPlatform != stdenv.hostPlatform
        ) " 'AR=${stdenv.cc.targetPrefix}ar rcu'"
      })

      installFlagsArray=( TO_BIN="lua luac" INSTALL_DATA='cp -d' \
        TO_LIB="${
          if stdenv.isDarwin then
            "liblua.${finalAttrs.version}.dylib"
          else
            (
              "liblua.a"
              + lib.optionalString (
                !staticOnly
              ) " liblua.so liblua.so.${luaversion} liblua.so.${finalAttrs.version}"
            )
        }" )

      runHook postConfigure
    '';
    inherit postConfigure;

    inherit postBuild;

    postInstall = ''
      mkdir -p "$out/nix-support" "$out/share/doc/lua" "$out/lib/pkgconfig"
      cp ${
        substituteAll {
          src = ./utils.sh;
          luapathsearchpaths = lib.escapeShellArgs finalAttrs.LuaPathSearchPaths;
          luacpathsearchpaths = lib.escapeShellArgs finalAttrs.LuaCPathSearchPaths;
        }
      } $out/nix-support/utils.sh
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
      Version: ${finalAttrs.version}
      Requires:
      Libs: -L$out/lib -llua
      Cflags: -I$out/include
      EOF
      ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua-${luaversion}.pc"
      ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua${luaversion}.pc"
      ln -s "$out/lib/pkgconfig/lua.pc" "$out/lib/pkgconfig/lua${
        lib.replaceStrings [ "." ] [ "" ] luaversion
      }.pc"

      # Make documentation outputs of different versions co-installable.
      mv $out/share/doc/lua $out/share/doc/lua-${finalAttrs.version}
    '';

    # copied from python
    passthru =
      let
        # When we override the interpreter we also need to override the spliced versions of the interpreter
        inputs' = lib.filterAttrs (n: v: !lib.isDerivation v && n != "passthruFun") inputs;
        override =
          attr:
          let
            lua = attr.override (inputs' // { self = lua; });
          in
          lua;
      in
      passthruFun rec {
        inherit
          self
          luaversion
          packageOverrides
          luaAttr
          ;
        executable = "lua";
        luaOnBuildForBuild = override pkgsBuildBuild.${luaAttr};
        luaOnBuildForHost = override pkgsBuildHost.${luaAttr};
        luaOnBuildForTarget = override pkgsBuildTarget.${luaAttr};
        luaOnHostForHost = override pkgsHostHost.${luaAttr};
        luaOnTargetForTarget = lib.optionalAttrs (lib.hasAttr luaAttr pkgsTargetTarget) (
          override pkgsTargetTarget.${luaAttr}
        );
      };

    meta = {
      homepage = "https://www.lua.org";
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
  }
)
