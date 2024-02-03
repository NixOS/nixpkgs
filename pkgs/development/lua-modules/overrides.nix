# do not add pkgs, it messes up splicing
{ stdenv
, cargo
, cmake
, curl
, cyrus_sasl
, dbus
, expat
, fetchFromGitHub
, fetchpatch
, fetchurl
, fixDarwinDylibNames
, glib
, glibc
, gmp
, gnulib
, gnum4
, gobject-introspection
, imagemagick
, installShellFiles
, lib
, libevent
, libiconv
, libmpack
, libmysqlclient
, libuuid
, libuv
, libxcrypt
, libyaml
, mariadb
, magic-enum
, mpfr
, neovim-unwrapped
, openldap
, openssl
, pcre
, pkg-config
, postgresql
, readline
, rustPlatform
, sol2
, sqlite
, tomlplusplus
, unbound
, vimPlugins
, vimUtils
, yajl
, zlib
, zziplib
}:

final: prev:
with prev;
{
  ##########################################3
  #### manual fixes for generated packages
  ##########################################3
  bit32 = prev.bit32.overrideAttrs (oa: {
    # Small patch in order to no longer redefine a Lua 5.2 function that Luajit
    # 2.1 also provides, see https://github.com/LuaJIT/LuaJIT/issues/325 for
    # more
    patches = [
      ./bit32.patch
    ];
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
  });

  busted = prev.busted.overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [
      installShellFiles
    ];
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace "'lua_cliargs = 3.0-1'," "'lua_cliargs >= 3.0-1',"
    '';
    postInstall = ''
      installShellCompletion --cmd busted \
        --zsh completions/zsh/_busted \
        --bash completions/bash/busted.bash
    '';
  });

  cqueues = prev.cqueues.overrideAttrs (oa: rec {
    # Parse out a version number without the Lua version inserted
    version = with lib; let
      version' = prev.cqueues.version;
      rel = splitVersion version';
      date = head rel;
      rev = last (splitString "-" (last rel));
    in
    "${date}-${rev}";

    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";

    nativeBuildInputs = oa.nativeBuildInputs ++ [
      gnum4
    ];

    externalDeps = [
      { name = "CRYPTO"; dep = openssl; }
      { name = "OPENSSL"; dep = openssl; }
    ];

    # Upstream rockspec is pointlessly broken into separate rockspecs, per Lua
    # version, which doesn't work well for us, so modify it
    postConfigure = let inherit (prev.cqueues) pname; in
      ''
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

  cyrussasl = prev.cyrussasl.overrideAttrs (drv: {
    externalDeps = [
      { name = "LIBSASL"; dep = cyrus_sasl; }
    ];
  });

  fennel = prev.fennel.overrideAttrs(oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [
      installShellFiles
    ];
    postInstall = ''
      installManPage fennel.1
    '';
  });

  http = prev.http.overrideAttrs (oa: {
    patches = [
      (fetchpatch {
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

  ldbus = prev.ldbus.overrideAttrs (oa: {
    extraVariables = {
      DBUS_DIR = "${dbus.lib}";
      DBUS_ARCH_INCDIR = "${dbus.lib}/lib/dbus-1.0/include";
      DBUS_INCDIR = "${dbus.dev}/include/dbus-1.0";
    };
    buildInputs = [
      dbus
    ];
  });

  ljsyscall = prev.ljsyscall.overrideAttrs (oa: rec {
    version = "unstable-20180515";
    # package hasn't seen any release for a long time
    src = fetchFromGitHub {
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
    meta.broken = luaOlder "5.1" || luaAtLeast "5.3";

    propagatedBuildInputs = with lib; oa.propagatedBuildInputs ++ optional (!isLuaJIT) luaffi;
  });

  lgi = prev.lgi.overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [
      pkg-config
    ];
    buildInputs = [
      glib
      gobject-introspection
    ];
    patches = [
      (fetchpatch {
        name = "lgi-find-cairo-through-typelib.patch";
        url = "https://github.com/psychon/lgi/commit/46a163d9925e7877faf8a4f73996a20d7cf9202a.patch";
        sha256 = "0gfvvbri9kyzhvq3bvdbj2l6mwvlz040dk4mrd5m9gz79f7w109c";
      })
    ];

    # https://github.com/lgi-devs/lgi/pull/300
    postPatch = ''
      substituteInPlace lgi/Makefile tests/Makefile \
        --replace 'PKG_CONFIG =' 'PKG_CONFIG ?='
    '';

    # there is only a rockspec.in in the repo, the actual rockspec must be generated
    preConfigure = ''
      make rock
    '';
  });

  lmathx = prev.luaLib.overrideLuarocks prev.lmathx (drv:
    if luaAtLeast "5.1" && luaOlder "5.2" then {
      version = "20120430.51-1";
      knownRockspec = (fetchurl {
        url = "https://luarocks.org/lmathx-20120430.51-1.rockspec";
        sha256 = "148vbv2g3z5si2db7rqg5bdily7m4sjyh9w6r3jnx3csvfaxyhp0";
      }).outPath;
      src = fetchurl {
        url = "https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/5.1/lmathx.tar.gz";
        sha256 = "0sa553d0zlxhvpsmr4r7d841f16yq4wr3fg7i07ibxkz6yzxax51";
      };
    } else
      if luaAtLeast "5.2" && luaOlder "5.3" then {
        version = "20120430.52-1";
        knownRockspec = (fetchurl {
          url = "https://luarocks.org/lmathx-20120430.52-1.rockspec";
          sha256 = "14rd625sipakm72wg6xqsbbglaxyjba9nsajsfyvhg0sz8qjgdya";
        }).outPath;
        src = fetchurl {
          url = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/lmathx.tar.gz";
          sha256 = "19dwa4z266l2njgi6fbq9rak4rmx2fsx1s0p9sl166ar3mnrdwz5";
        };
      } else
        {
          disabled = luaOlder "5.1" || luaAtLeast "5.5";
          # works fine with 5.4 as well
          postConfigure = ''
            substituteInPlace ''${rockspecFilename} \
              --replace 'lua ~> 5.3' 'lua >= 5.3, < 5.5'
          '';
        });

  lmpfrlib = prev.lmpfrlib.overrideAttrs (oa: {
    externalDeps = [
      { name = "GMP"; dep = gmp; }
      { name = "MPFR"; dep = mpfr; }
    ];
    unpackPhase = ''
      cp $src $(stripHash $src)
    '';
  });

  lrexlib-gnu = prev.lrexlib-gnu.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      gnulib
    ];
  });

  lrexlib-pcre = prev.lrexlib-pcre.overrideAttrs (oa: {
    externalDeps = [
      { name = "PCRE"; dep = pcre; }
    ];
  });

  lrexlib-posix = prev.lrexlib-posix.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      glibc.dev
    ];
  });

  lua-curl = prev.lua-curl.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      curl.dev
    ];
  });

  lua-iconv = prev.lua-iconv.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      libiconv
    ];
  });

  lua-lsp = prev.lua-lsp.overrideAttrs (oa: {
    # until Alloyed/lua-lsp#28
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace '"dkjson ~> 2.5",' '"dkjson >= 2.5",'
    '';
  });

  lua-zlib = prev.lua-zlib.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      zlib.dev
    ];
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
  });

  luadbi-mysql = prev.luadbi-mysql.overrideAttrs (oa: {
    extraVariables = {
      # Can't just be /include and /lib, unfortunately needs the trailing 'mysql'
      MYSQL_INCDIR = "${libmysqlclient.dev}/include/mysql";
      MYSQL_LIBDIR = "${libmysqlclient}/lib/mysql";
    };
    buildInputs = oa.buildInputs ++ [
      mariadb.client
      libmysqlclient
    ];
  });

  luadbi-postgresql = prev.luadbi-postgresql.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      postgresql
    ];
  });

  luadbi-sqlite3 = prev.luadbi-sqlite3.overrideAttrs (oa: {
    externalDeps = [
      { name = "SQLITE"; dep = sqlite; }
    ];
  });

  luaevent = prev.luaevent.overrideAttrs (oa: {
    propagatedBuildInputs = oa.propagatedBuildInputs ++ [
      luasocket
    ];
    externalDeps = [
      { name = "EVENT"; dep = libevent; }
    ];
    disabled = luaOlder "5.1" || luaAtLeast "5.4";
  });

  luaexpat = prev.luaexpat.overrideAttrs (_: {
    externalDeps = [
      { name = "EXPAT"; dep = expat; }
    ];
  });

  # TODO Somehow automatically amend buildInputs for things that need luaffi
  # but are in luajitPackages?
  luaffi = prev.luaffi.overrideAttrs (oa: {
    # The packaged .src.rock version is pretty old, and doesn't work with Lua 5.3
    src = fetchFromGitHub {
      owner = "facebook";
      repo = "luaffifb";
      rev = "532c757e51c86f546a85730b71c9fef15ffa633d";
      sha256 = "1nwx6sh56zfq99rcs7sph0296jf6a9z72mxknn0ysw9fd7m1r8ig";
    };
    knownRockspec = with prev.luaffi; "${pname}-${version}.rockspec";
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4" || isLuaJIT;
  });

  lualdap = prev.lualdap.overrideAttrs (_: {
    externalDeps = [
      { name = "LDAP"; dep = openldap; }
    ];
  });

  luaossl = prev.luaossl.overrideAttrs (_: {
    externalDeps = [
      { name = "CRYPTO"; dep = openssl; }
      { name = "OPENSSL"; dep = openssl; }
    ];
  });

  luaposix = prev.luaposix.overrideAttrs (_: {
    externalDeps = [
      { name = "CRYPT"; dep = libxcrypt; }
    ];
  });

  luasec = prev.luasec.overrideAttrs (oa: {
    externalDeps = [
      { name = "OPENSSL"; dep = openssl; }
    ];
  });

  luasql-sqlite3 = prev.luasql-sqlite3.overrideAttrs (oa: {
    externalDeps = [
      { name = "SQLITE"; dep = sqlite; }
    ];
  });

  luasystem = prev.luasystem.overrideAttrs (oa: lib.optionalAttrs stdenv.isLinux {
    buildInputs = [ glibc.out ];
  });

  luazip = prev.luazip.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      zziplib
    ];
  });

  lua-yajl =  prev.lua-yajl.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      yajl
    ];
  });

  luaunbound = prev.luaunbound.overrideAttrs (oa: {
    externalDeps = [
      { name = "libunbound"; dep = unbound; }
    ];
  });

  lua-subprocess = prev.lua-subprocess.overrideAttrs (oa: {
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
  });

  lush-nvim = prev.lush-nvim.overrideAttrs (drv: {
    doCheck = false;
  });

  luuid = prev.luuid.overrideAttrs (oa: {
    externalDeps = [
      { name = "LIBUUID"; dep = libuuid; }
    ];
    # Trivial patch to make it work in both 5.1 and 5.2.  Basically just the
    # tiny diff between the two upstream versions placed behind an #if.
    # Upstreams:
    # 5.1: http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/5.1/luuid.tar.gz
    # 5.2: http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/luuid.tar.gz
    patchFlags = [ "-p2" ];
    patches = [
      ./luuid.patch
    ];
    postConfigure =  ''
      sed -Ei ''${rockspecFilename} -e 's|lua >= 5.2|lua >= 5.1,|'
    '';
    meta = oa.meta // {
      broken = luaOlder "5.1" || (luaAtLeast "5.4");
      platforms = lib.platforms.linux;
    };
  });


  # as advised in https://github.com/luarocks/luarocks/issues/1402#issuecomment-1080616570
  # we shouldn't use luarocks machinery to build complex cmake components
  libluv = stdenv.mkDerivation {

    pname = "libluv";
    inherit (prev.luv) version meta src;

    cmakeFlags = [
      "-DBUILD_SHARED_LIBS=ON"
      "-DBUILD_MODULE=OFF"
      "-DWITH_SHARED_LIBUV=ON"
      "-DLUA_BUILD_TYPE=System"
      "-DWITH_LUA_ENGINE=${if isLuaJIT then "LuaJit" else "Lua"}"
    ];

    # to make sure we dont use bundled deps
    postUnpack = ''
      rm -rf deps/lua deps/libuv
    '';

    buildInputs = [ libuv final.lua ];

    nativeBuildInputs = [ pkg-config cmake ]
      ++ lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];
  };

  luv = prev.luv.overrideAttrs (oa: {

    nativeBuildInputs = oa.nativeBuildInputs ++ [ pkg-config ];
    buildInputs = [ libuv ];

    # Use system libuv instead of building local and statically linking
    extraVariables = {
      WITH_SHARED_LIBUV = "ON";
    };

    # we unset the LUA_PATH since the hook erases the interpreter defaults (To fix)
    # tests is not run since they are not part of the tarball anymore
    preCheck = ''
      unset LUA_PATH
      rm tests/test-{dns,thread}.lua
    '';
  });

  lyaml = prev.lyaml.overrideAttrs (oa: {
    buildInputs = [
      libyaml
    ];
  });

  magick = prev.magick.overrideAttrs (oa: {
    buildInputs = oa.buildInputs ++ [
      imagemagick
    ];

    # Fix MagickWand not being found in the pkg-config search path
    patches = [
      ./magick.patch
    ];

    postPatch = ''
      substituteInPlace magick/wand/lib.lua \
        --replace @nix_wand@ ${imagemagick}/lib/libMagickWand-7.Q16HDRI.so
    '';

    # Requires ffi
    meta.broken = !isLuaJIT;
  });

  mpack = prev.mpack.overrideAttrs (drv: {
    buildInputs = (drv.buildInputs or []) ++ [ libmpack ];
    env = {
      # the rockspec doesn't use the makefile so you may need to export more flags
      USE_SYSTEM_LUA = "yes";
      USE_SYSTEM_MPACK = "yes";
    };
  });

  rapidjson = prev.rapidjson.overrideAttrs (oa: {
    preBuild = ''
      sed -i '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt
      sed -i '/set(CMAKE_C_FLAGS/d' CMakeLists.txt
    '';
  });

  readline = prev.readline.overrideAttrs (oa: {
    propagatedBuildInputs = oa.propagatedBuildInputs ++ [ readline.out ];
    extraVariables = rec {
      READLINE_INCDIR = "${readline.dev}/include";
      HISTORY_INCDIR = READLINE_INCDIR;
    };
    unpackCmd = ''
      unzip "$curSrc"
      tar xf *.tar.gz
    '';
    # Without this, source root is wrongly set to ./readline-2.6/doc
    sourceRoot = "readline-${lib.versions.majorMinor oa.version}";
  });

  sqlite = prev.sqlite.overrideAttrs (drv: {

    doCheck = true;
    nativeCheckInputs = [ final.plenary-nvim neovim-unwrapped ];

    # we override 'luarocks test' because otherwise neovim doesn't find/load the plenary plugin
    checkPhase = ''
      export LIBSQLITE="${sqlite.out}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary}"
      export HOME="$TMPDIR";

      nvim --headless -i NONE \
        -u test/minimal_init.vim --cmd "set rtp+=${vimPlugins.plenary-nvim}" \
        -c "PlenaryBustedDirectory test/auto/ { minimal_init = './test/minimal_init.vim' }"
    '';

  });

  std-_debug = prev.std-_debug.overrideAttrs (oa: {
    # run make to generate lib/std/_debug/version.lua
    preConfigure = ''
      make all
    '';
  });

  std-normalize = prev.std-normalize.overrideAttrs (oa: {
    # run make to generate lib/std/_debug/version.lua
    preConfigure = ''
      make all
    '';
  });

  toml = prev.toml.overrideAttrs (oa: {
    patches = [ ./toml.patch ];

    propagatedBuildInputs = oa.propagatedBuildInputs ++ [ magic-enum sol2 ];

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace \
        "TOML_PLUS_PLUS_SRC" \
        "${tomlplusplus.src}"
    '';
  });

  toml-edit = prev.toml-edit.overrideAttrs (oa: {

    cargoDeps = rustPlatform.fetchCargoTarball {
      src = oa.src;
      hash = "sha256-pLAisfnSDoAToQO/kdKTdic6vEug7/WFNtgOfj0bRAE=";
    };

    nativeBuildInputs = oa.nativeBuildInputs ++ [ cargo rustPlatform.cargoSetupHook ];

  });

  vstruct = prev.vstruct.overrideAttrs (_: {
    meta.broken = (luaOlder "5.1" || luaAtLeast "5.4");
  });

  vusted = prev.vusted.overrideAttrs (_: {
    # make sure vusted_entry.vim doesn't get wrapped
    postInstall = ''
      chmod -x $out/bin/vusted_entry.vim
    '';
  });


  # aliases
  cjson = prev.lua-cjson;
}
