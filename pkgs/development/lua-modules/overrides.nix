{ pkgs }:
final: prev:
with prev;
{
  ##########################################3
  #### manual fixes for generated packages
  ##########################################3
  bit32 = prev.bit32.overrideAttrs(oa: {
    # Small patch in order to no longer redefine a Lua 5.2 function that Luajit
    # 2.1 also provides, see https://github.com/LuaJIT/LuaJIT/issues/325 for
    # more
    patches = [
      ./bit32.patch
    ];
  });

  busted = prev.busted.overrideAttrs(oa: {
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace "'lua_cliargs = 3.0-1'," "'lua_cliargs >= 3.0-1',"
    '';
    postInstall = ''
      install -D completions/zsh/_busted $out/share/zsh/site-functions/_busted
      install -D completions/bash/busted.bash $out/share/bash-completion/completions/busted
    '';
  });

  cqueues = (prev.lib.overrideLuarocks prev.cqueues (drv: {
    nativeBuildInputs = [
      pkgs.gnum4
    ];
    externalDeps = [
      { name = "CRYPTO"; dep = pkgs.openssl; }
      { name = "OPENSSL"; dep = pkgs.openssl; }
    ];
    disabled = luaOlder "5.1" || luaAtLeast "5.4";
  })).overrideAttrs(oa: rec {
    # Parse out a version number without the Lua version inserted
    version = with pkgs.lib; let
      version' = prev.cqueues.version;
      rel = splitVersion version';
      date = head rel;
      rev = last (splitString "-" (last rel));
    in "${date}-${rev}";
    # Upstream rockspec is pointlessly broken into separate rockspecs, per Lua
    # version, which doesn't work well for us, so modify it
    postConfigure = let inherit (prev.cqueues) pname; in ''
      # 'all' target auto-detects correct Lua version, which is fine for us as
      # we only have the right one available :)
      sed -Ei ''${rockspecFilename} \
        -e 's|lua == 5.[[:digit:]]|lua >= 5.1, <= 5.3|' \
        -e 's|build_target = "[^"]+"|build_target = "all"|' \
        -e 's|version = "[^"]+"|version = "${version}"|'
      specDir=$(dirname ''${rockspecFilename})
      cp ''${rockspecFilename} "$specDir/${pname}-${version}.rockspec"
      rockspecFilename="$specDir/${pname}-${version}.rockspec"
    '';
  });

  cyrussasl = prev.lib.overrideLuarocks prev.cyrussasl (drv: {
    externalDeps = [
      { name = "LIBSASL"; dep = pkgs.cyrus_sasl; }
    ];
  });

  http = prev.http.overrideAttrs(oa: {
    patches = [
      (pkgs.fetchpatch {
        name = "invalid-state-progression.patch";
        url = "https://github.com/daurnimator/lua-http/commit/cb7b59474a.diff";
        sha256 = "1vmx039n3nqfx50faqhs3wgiw28ws416rhw6vh6srmh9i826dac7";
      })
    ];
    /* TODO: separate docs derivation? (pandoc is heavy)
    nativeBuildInputs = [ pandoc ];
    makeFlags = [ "-C doc" "lua-http.html" "lua-http.3" ];
    */
  });

  ldbus = prev.lib.overrideLuarocks prev.ldbus (drv: {
    extraVariables = {
      DBUS_DIR="${pkgs.dbus.lib}";
      DBUS_ARCH_INCDIR="${pkgs.dbus.lib}/lib/dbus-1.0/include";
      DBUS_INCDIR="${pkgs.dbus.dev}/include/dbus-1.0";
    };
    buildInputs = with pkgs; [
      dbus
    ];
  });

  ljsyscall = prev.ljsyscall.overrideAttrs(oa: rec {
    version = "unstable-20180515";
    # package hasn't seen any release for a long time
    src = pkgs.fetchFromGitHub {
      owner = "justincormack";
      repo = "ljsyscall";
      rev = "e587f8c55aad3955dddab3a4fa6c1968037b5c6e";
      sha256 = "06v52agqyziwnbp2my3r7liv245ddmb217zmyqakh0ldjdsr8lz4";
    };
    knownRockspec = "rockspec/ljsyscall-scm-1.rockspec";
    # actually library works fine with lua 5.2
    preConfigure = ''
      sed -i 's/lua == 5.1/lua >= 5.1, < 5.3/' ${knownRockspec}
    '';
    disabled = luaOlder "5.1" || luaAtLeast "5.3";

    propagatedBuildInputs = with pkgs.lib; optional (!isLuaJIT) luaffi;
  });

  lgi = prev.lib.overrideLuarocks prev.lgi (drv: {
    nativeBuildInputs = [
      pkgs.pkg-config
    ];
    buildInputs = [
      pkgs.glib
      pkgs.gobject-introspection
    ];
    patches = [
      (pkgs.fetchpatch {
        name = "lgi-find-cairo-through-typelib.patch";
        url = "https://github.com/psychon/lgi/commit/46a163d9925e7877faf8a4f73996a20d7cf9202a.patch";
        sha256 = "0gfvvbri9kyzhvq3bvdbj2l6mwvlz040dk4mrd5m9gz79f7w109c";
      })
    ];

    # there is only a rockspec.in in the repo, the actual rockspec must be generated
    preConfigure = ''
      make rock
    '';
  });

  lrexlib-gnu = prev.lib.overrideLuarocks prev.lrexlib-gnu (drv: {
    buildInputs = [
      pkgs.gnulib
    ];
  });

  lrexlib-pcre = prev.lib.overrideLuarocks prev.lrexlib-pcre (drv: {
    externalDeps = [
      { name = "PCRE"; dep = pkgs.pcre; }
    ];
  });

  lrexlib-posix = prev.lib.overrideLuarocks prev.lrexlib-posix (drv: {
    buildInputs = [
      pkgs.glibc.dev
    ];
  });

  lua-iconv = prev.lib.overrideLuarocks prev.lua-iconv (drv: {
    buildInputs = [
      pkgs.libiconv
    ];
  });

  lua-lsp = prev.lua-lsp.overrideAttrs(oa: {
    # until Alloyed/lua-lsp#28
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace '"lpeglabel ~> 1.5",' '"lpeglabel >= 1.5",'
    '';
  });

  lua-zlib = prev.lib.overrideLuarocks prev.lua-zlib (drv: {
    buildInputs = [
      pkgs.zlib.dev
    ];
    disabled = luaOlder "5.1" || luaAtLeast "5.4";
  });

  luadbi-mysql = prev.lib.overrideLuarocks prev.luadbi-mysql (drv: {
    extraVariables = {
      # Can't just be /include and /lib, unfortunately needs the trailing 'mysql'
      MYSQL_INCDIR="${pkgs.libmysqlclient.dev}/include/mysql";
      MYSQL_LIBDIR="${pkgs.libmysqlclient}/lib/mysql";
    };
    buildInputs = [
      pkgs.mariadb.client
      pkgs.libmysqlclient
    ];
  });

  luadbi-postgresql = prev.lib.overrideLuarocks prev.luadbi-postgresql (drv: {
    buildInputs = [
      pkgs.postgresql
    ];
  });

  luadbi-sqlite3 = prev.lib.overrideLuarocks prev.luadbi-sqlite3 (drv: {
    externalDeps = [
      { name = "SQLITE"; dep = pkgs.sqlite; }
    ];
  });

  luaevent = prev.lib.overrideLuarocks prev.luaevent (drv: {
    propagatedBuildInputs = [
      luasocket
    ];
    externalDeps = [
      { name = "EVENT"; dep = pkgs.libevent; }
    ];
    disabled = luaOlder "5.1" || luaAtLeast "5.4";
  });

  luaexpat = prev.lib.overrideLuarocks prev.luaexpat (drv: {
    externalDeps = [
      { name = "EXPAT"; dep = pkgs.expat; }
    ];
    patches = [
      ./luaexpat.patch
    ];
  });

  # TODO Somehow automatically amend buildInputs for things that need luaffi
  # but are in luajitPackages?
  luaffi = prev.lib.overrideLuarocks prev.luaffi (drv: {
    # The packaged .src.rock version is pretty old, and doesn't work with Lua 5.3
    src = pkgs.fetchFromGitHub {
      owner = "facebook"; repo = "luaffifb";
      rev = "532c757e51c86f546a85730b71c9fef15ffa633d";
      sha256 = "1nwx6sh56zfq99rcs7sph0296jf6a9z72mxknn0ysw9fd7m1r8ig";
    };
    knownRockspec = with prev.luaffi; "${pname}-${version}.rockspec";
    disabled = luaOlder "5.1" || luaAtLeast "5.4" || isLuaJIT;
  });

  luaossl = prev.lib.overrideLuarocks prev.luaossl (drv: {
    externalDeps = [
      { name = "CRYPTO"; dep = pkgs.openssl; }
      { name = "OPENSSL"; dep = pkgs.openssl; }
    ];
  });

  luasec = prev.lib.overrideLuarocks prev.luasec (drv: {
    externalDeps = [
      { name = "OPENSSL"; dep = pkgs.openssl; }
    ];
  });

  luasql-sqlite3 = prev.lib.overrideLuarocks prev.luasql-sqlite3 (drv: {
    externalDeps = [
      { name = "SQLITE"; dep = pkgs.sqlite; }
    ];
  });

  luasystem = prev.lib.overrideLuarocks prev.luasystem (drv: { buildInputs = [ pkgs.glibc.out ]; });

  luazip = prev.lib.overrideLuarocks prev.luazip (drv: {
    buildInputs = [
      pkgs.zziplib
    ];
  });

  lua-yajl = prev.lib.overrideLuarocks prev.lua-yajl (drv: {
    buildInputs = [
      pkgs.yajl
    ];
  });

  luuid = (prev.lib.overrideLuarocks prev.luuid (drv: {
    externalDeps = [
      { name = "LIBUUID"; dep = pkgs.libuuid; }
    ];
    disabled = luaOlder "5.1" || (luaAtLeast "5.4");
  })).overrideAttrs(oa: {
    meta = oa.meta // {
      platforms = pkgs.lib.platforms.linux;
    };
    # Trivial patch to make it work in both 5.1 and 5.2.  Basically just the
    # tiny diff between the two upstream versions placed behind an #if.
    # Upstreams:
    # 5.1: http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/5.1/luuid.tar.gz
    # 5.2: http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/luuid.tar.gz
    patchFlags = [ "-p2" ];
    patches = [
      ./luuid.patch
    ];
    postConfigure = let inherit (prev.luuid) version pname; in ''
      sed -Ei ''${rockspecFilename} -e 's|lua >= 5.2|lua >= 5.1,|'
    '';
  });

  luv = prev.lib.overrideLuarocks prev.luv (drv: {
    # Use system libuv instead of building local and statically linking
    # This is a hacky way to specify -DWITH_SHARED_LIBUV=ON which
    # is not possible with luarocks and the current luv rockspec
    # While at it, remove bundled libuv source entirely to be sure.
    # We may wish to drop bundled lua submodules too...
    preBuild = ''
     sed -i 's,\(option(WITH_SHARED_LIBUV.*\)OFF,\1ON,' CMakeLists.txt
     rm -rf deps/libuv
    '';

    buildInputs = [ pkgs.libuv ];

    passthru = {
      libluv = final.luv.overrideAttrs (oa: {
        preBuild = final.luv.preBuild + ''
          sed -i 's,\(option(BUILD_MODULE.*\)ON,\1OFF,' CMakeLists.txt
          sed -i 's,\(option(BUILD_SHARED_LIBS.*\)OFF,\1ON,' CMakeLists.txt
          sed -i 's,${"\${.*INSTALL_INC_DIR}"},${placeholder "out"}/include/luv,' CMakeLists.txt
        '';

        nativeBuildInputs = [ pkgs.fixDarwinDylibNames ];

        # Fixup linking libluv.dylib, for some reason it's not linked against lua correctly.
        NIX_LDFLAGS = pkgs.lib.optionalString pkgs.stdenv.isDarwin
          (if isLuaJIT then "-lluajit-${lua.luaversion}" else "-llua");
      });
    };
  });

  lyaml = prev.lib.overrideLuarocks prev.lyaml (oa: {
    buildInputs = [
      pkgs.libyaml
    ];
  });

  mpack = prev.lib.overrideLuarocks prev.mpack (drv: {
    buildInputs = [ pkgs.libmpack ];
    # the rockspec doesn't use the makefile so you may need to export more flags
    USE_SYSTEM_LUA = "yes";
    USE_SYSTEM_MPACK = "yes";
  });

  rapidjson = prev.rapidjson.overrideAttrs(oa: {
    preBuild = ''
      sed -i '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt
      sed -i '/set(CMAKE_C_FLAGS/d' CMakeLists.txt
    '';
  });

  readline = (prev.lib.overrideLuarocks prev.readline (drv: {
    unpackCmd = ''
      unzip "$curSrc"
      tar xf *.tar.gz
    '';
    propagatedBuildInputs = prev.readline.propagatedBuildInputs ++ [ pkgs.readline.out ];
    extraVariables = rec {
      READLINE_INCDIR = "${pkgs.readline.dev}/include";
      HISTORY_INCDIR = READLINE_INCDIR;
    };
  })).overrideAttrs (old: {
    # Without this, source root is wrongly set to ./readline-2.6/doc
    setSourceRoot = ''
      sourceRoot=./readline-3.0
    '';
  });

  std-_debug = prev.std-_debug.overrideAttrs(oa: {
    # run make to generate lib/std/_debug/version.lua
    preConfigure = ''
      make all
    '';
  });

  std-normalize = prev.std-normalize.overrideAttrs(oa: {
    # run make to generate lib/std/_debug/version.lua
    preConfigure = ''
      make all
    '';
  });

  # TODO just while testing, remove afterwards
  # toVimPlugin should do it instead
  gitsigns-nvim = prev.gitsigns-nvim.overrideAttrs(oa: {
    nativeBuildInputs = oa.nativeBuildInputs or [] ++ [ pkgs.vimUtils.vimGenDocHook ];
  });

  # aliases
  cjson = prev.lua-cjson;
}
