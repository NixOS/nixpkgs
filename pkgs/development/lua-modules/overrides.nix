{ pkgs,  ... }:
self: super:
with super;
{
  ##########################################3
  #### manual fixes for generated packages
  ##########################################3
  bit32 = super.bit32.override({
    # Small patch in order to no longer redefine a Lua 5.2 function that Luajit
    # 2.1 also provides, see https://github.com/LuaJIT/LuaJIT/issues/325 for
    # more
    patches = [
      ./bit32.patch
    ];
  });

  busted = super.busted.override({
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace "'lua_cliargs = 3.0-1'," "'lua_cliargs >= 3.0-1',"
    '';
    postInstall = ''
      install -D completions/zsh/_busted $out/share/zsh/site-functions/_busted
      install -D completions/bash/busted.bash $out/share/bash-completion/completions/busted
    '';
  });

  cqueues = super.cqueues.override(rec {
    # Parse out a version number without the Lua version inserted
    version = with pkgs.lib; let
      version' = super.cqueues.version;
      rel = splitVersion version';
      date = head rel;
      rev = last (splitString "-" (last rel));
    in "${date}-${rev}";
    nativeBuildInputs = [
      pkgs.gnum4
    ];
    externalDeps = [
      { name = "CRYPTO"; dep = pkgs.openssl; }
      { name = "OPENSSL"; dep = pkgs.openssl; }
    ];

    # https://github.com/wahern/cqueues/issues/227
    NIX_CFLAGS_COMPILE = with pkgs.stdenv; lib.optionalString hostPlatform.isDarwin
      "-DCLOCK_MONOTONIC -DCLOCK_REALTIME";

    disabled = luaOlder "5.1" || luaAtLeast "5.4";
    # Upstream rockspec is pointlessly broken into separate rockspecs, per Lua
    # version, which doesn't work well for us, so modify it
    postConfigure = let inherit (super.cqueues) pname; in ''
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

  cyrussasl = super.cyrussasl.override({
    externalDeps = [
      { name = "LIBSASL"; dep = pkgs.cyrus_sasl; }
    ];
  });

  http = super.http.override({
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

  ljsyscall = super.ljsyscall.override(rec {
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

  lgi = super.lgi.override({
    nativeBuildInputs = [
      pkgs.pkgconfig
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
  });

  lrexlib-gnu = super.lrexlib-gnu.override({
    buildInputs = [
      pkgs.gnulib
    ];
  });

  lrexlib-pcre = super.lrexlib-pcre.override({
    externalDeps = [
      { name = "PCRE"; dep = pkgs.pcre; }
    ];
  });

  lrexlib-posix = super.lrexlib-posix.override({
    buildInputs = [
      pkgs.glibc.dev
    ];
  });

  ltermbox = super.ltermbox.override( {
    disabled = !isLua51 || isLuaJIT;
  });

  lua-iconv = super.lua-iconv.override({
    buildInputs = [
      pkgs.libiconv
    ];
  });

  lua-zlib = super.lua-zlib.override({
    buildInputs = [
      pkgs.zlib.dev
    ];
    disabled = luaOlder "5.1" || luaAtLeast "5.4";
  });

  luadbi-mysql = super.luadbi-mysql.override({
    extraVariables = ''
      -- Can't just be /include and /lib, unfortunately needs the trailing 'mysql'
      MYSQL_INCDIR='${pkgs.libmysqlclient}/include/mysql';
      MYSQL_LIBDIR='${pkgs.libmysqlclient}/lib/mysql';
    '';
    buildInputs = [
      pkgs.mysql.client
      pkgs.libmysqlclient
    ];
  });

  luadbi-postgresql = super.luadbi-postgresql.override({
    buildInputs = [
      pkgs.postgresql
    ];
  });

  luadbi-sqlite3 = super.luadbi-sqlite3.override({
    externalDeps = [
      { name = "SQLITE"; dep = pkgs.sqlite; }
    ];
  });

  luaevent = super.luaevent.override({
    propagatedBuildInputs = [
      luasocket
    ];
    externalDeps = [
      { name = "EVENT"; dep = pkgs.libevent; }
    ];
    disabled = luaOlder "5.1" || luaAtLeast "5.4";
  });

  luaexpat = super.luaexpat.override({
    externalDeps = [
      { name = "EXPAT"; dep = pkgs.expat; }
    ];
  });

  # TODO Somehow automatically amend buildInputs for things that need luaffi
  # but are in luajitPackages?
  luaffi = super.luaffi.override({
    # The packaged .src.rock version is pretty old, and doesn't work with Lua 5.3
    src = pkgs.fetchFromGitHub {
      owner = "facebook"; repo = "luaffifb";
      rev = "532c757e51c86f546a85730b71c9fef15ffa633d";
      sha256 = "1nwx6sh56zfq99rcs7sph0296jf6a9z72mxknn0ysw9fd7m1r8ig";
    };
    knownRockspec = with super.luaffi; "${pname}-${version}.rockspec";
    disabled = luaOlder "5.1" || luaAtLeast "5.4" || isLuaJIT;
  });

  luaossl = super.luaossl.override({
    externalDeps = [
      { name = "CRYPTO"; dep = pkgs.openssl; }
      { name = "OPENSSL"; dep = pkgs.openssl; }
    ];
  });

  luasec = super.luasec.override({
    externalDeps = [
      { name = "OPENSSL"; dep = pkgs.openssl; }
    ];
  });

  luasql-sqlite3 = super.luasql-sqlite3.override({
    externalDeps = [
      { name = "SQLITE"; dep = pkgs.sqlite; }
    ];
  });

  luasystem = super.luasystem.override({
    buildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [
      pkgs.glibc
    ];
  });

  luazip = super.luazip.override({
    buildInputs = [
      pkgs.zziplib
    ];
  });

  lua-yajl = super.lua-yajl.override({
    buildInputs = [
      pkgs.yajl
    ];
  });

  luuid = super.luuid.override(old: {
    externalDeps = [
      { name = "LIBUUID"; dep = pkgs.libuuid; }
    ];
    meta = old.meta // {
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
    postConfigure = let inherit (super.luuid) version pname; in ''
      sed -Ei ''${rockspecFilename} -e 's|lua >= 5.2|lua >= 5.1,|'
    '';
    disabled = luaOlder "5.1" || (luaAtLeast "5.4");
  });

  luv = super.luv.override({
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
      libluv = self.luv.override ({
        preBuild = self.luv.preBuild + ''
          sed -i 's,\(option(BUILD_MODULE.*\)ON,\1OFF,' CMakeLists.txt
          sed -i 's,\(option(BUILD_SHARED_LIBS.*\)OFF,\1ON,' CMakeLists.txt
          sed -i 's,${"\${INSTALL_INC_DIR}"},${placeholder "out"}/include/luv,' CMakeLists.txt
        '';

        nativeBuildInputs = [ pkgs.fixDarwinDylibNames ];

        # Fixup linking libluv.dylib, for some reason it's not linked against lua correctly.
        NIX_LDFLAGS = pkgs.lib.optionalString pkgs.stdenv.isDarwin
          (if isLuaJIT then "-lluajit-${lua.luaversion}" else "-llua");
      });
    };
  });


  rapidjson = super.rapidjson.override({
    preBuild = ''
      sed -i '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt
      sed -i '/set(CMAKE_C_FLAGS/d' CMakeLists.txt
    '';
  });
}
