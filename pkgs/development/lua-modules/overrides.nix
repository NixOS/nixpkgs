# do not add pkgs, it messes up splicing
{ stdenv
, cargo
, cmake

# plenary utilities
, which
, findutils
, clang
, coreutils
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
, libpsl
, libuuid
, libuv
, libxcrypt
, libyaml
, luajitPackages
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
, tree-sitter
, unbound
, vimPlugins
, vimUtils
, yajl
, zlib
, zziplib
}:

final: prev:
let
  inherit (prev) luaOlder luaAtLeast lua isLuaJIT;
in
{
  argparse = prev.argparse.overrideAttrs(oa: {

    doCheck = true;
    checkInputs = [ final.busted ];

    checkPhase = ''
      runHook preCheck
      export LUA_PATH="src/?.lua;$LUA_PATH"
      busted spec/
      runHook postCheck
    '';
  });
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
        --replace-fail "'lua_cliargs = 3.0'," "'lua_cliargs >= 3.0-1',"
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

  fennel = prev.fennel.overrideAttrs(oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [
      installShellFiles
    ];
    postInstall = ''
      installManPage fennel.1
    '';
  });

  # Until https://github.com/swarn/fzy-lua/pull/8 is merged,
  # we have to invoke busted manually
  fzy = prev.fzy.overrideAttrs(oa: {
    doCheck = true;
    nativeCheckInputs = [ final.busted ];
    checkPhase = ''
      busted
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

  image-nvim = prev.image-nvim.overrideAttrs (oa: {
    propagatedBuildInputs = [
      lua
      luajitPackages.magick
    ];
  });

  ldbus = prev.ldbus.overrideAttrs (oa: {
    luarocksConfig = oa.luarocksConfig // {
      variables = {
        DBUS_DIR = "${dbus.lib}";
        DBUS_ARCH_INCDIR = "${dbus.lib}/lib/dbus-1.0/include";
        DBUS_INCDIR = "${dbus.dev}/include/dbus-1.0";
      };
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

    propagatedBuildInputs = with lib; oa.propagatedBuildInputs ++ optional (!isLuaJIT) final.luaffi;
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

    # Lua 5.4 support is experimental at the moment, see
    # https://github.com/lgi-devs/lgi/pull/249
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
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

    luarocksConfig = lib.recursiveUpdate oa.luarocksConfig {
      variables = {
        # Can't just be /include and /lib, unfortunately needs the trailing 'mysql'
        MYSQL_INCDIR = "${libmysqlclient.dev}/include/mysql";
        MYSQL_LIBDIR = "${libmysqlclient}/lib/mysql";
      };
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
      final.luasocket
    ];
    externalDeps = [
      { name = "EVENT"; dep = libevent; }
    ];
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
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

  # lua-resty-session =  prev.lua-resty-session.overrideAttrs (oa: {
  #   # lua_pack and lua-ffi-zlib are unpackaged, causing this package to not evaluate
  #   meta.broken = true;
  # });

  lua-resty-openidc =  prev.lua-resty-openidc.overrideAttrs (_: {
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace '"lua-resty-session >= 2.8, <= 3.10",' '"lua-resty-session >= 2.8",'
    '';
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

  lua-rtoml = prev.lua-rtoml.overrideAttrs (oa: {

    cargoDeps = rustPlatform.fetchCargoTarball {
      src = oa.src;
      hash = "sha256-EcP4eYsuOVeEol+kMqzsVHd8F2KoBdLzf6K0KsYToUY=";
    };

    propagatedBuildInputs = oa.propagatedBuildInputs ++ [ cargo rustPlatform.cargoSetupHook ];

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

  haskell-tools-nvim  = prev.haskell-tools-nvim.overrideAttrs(oa: {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [ final.nlua final.busted ];
    checkPhase = ''
      runHook preCheck
      export HOME=$(mktemp -d)
      busted --lua=nlua
      runHook postCheck
      '';
  });

  plenary-nvim = prev.plenary-nvim.overrideAttrs (oa: {
    postPatch = ''
      sed -Ei lua/plenary/curl.lua \
          -e 's@(command\s*=\s*")curl(")@\1${curl}/bin/curl\2@'
    '';

    # disabled for now because too flaky
    doCheck = false;
    # for env/find/ls
    checkInputs = [
      which
      neovim-unwrapped
      coreutils
      findutils
    ];

    checkPhase = ''
      runHook preCheck
      # remove failing tests, need internet access for instance
      rm tests/plenary/job_spec.lua tests/plenary/scandir_spec.lua tests/plenary/curl_spec.lua
      export HOME="$TMPDIR"
      make test
      runHook postCheck
    '';
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
    luarocksConfig = lib.recursiveUpdate oa.luarocksConfig {
      variables = { WITH_SHARED_LIBUV = "ON"; };
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
        --replace @nix_wand@ ${imagemagick}/lib/libMagickWand-7.Q16HDRI${stdenv.hostPlatform.extensions.sharedLibrary}
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

  nlua = prev.nlua.overrideAttrs(oa: {

    # patchShebang removes the nvim in nlua's shebang so we hardcode one
    postFixup = ''
      sed -i -e "1 s|.*|#\!${coreutils}/bin/env -S ${neovim-unwrapped}/bin/nvim -l|" "$out/bin/nlua"
      '';
    dontPatchShebangs = true;
  });

  psl = prev.psl.overrideAttrs (drv: {
    buildInputs = drv.buildInputs or [ ] ++ [ libpsl ];

    luarocksConfig.variables = drv.luarocksConfig.variables // {
      PSL_INCDIR = lib.getDev libpsl + "/include";
      PSL_DIR = lib.getLib libpsl;
    };
  });

  rapidjson = prev.rapidjson.overrideAttrs (oa: {
    preBuild = ''
      sed -i '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt
      sed -i '/set(CMAKE_C_FLAGS/d' CMakeLists.txt
    '';
  });

  # upstream broken, can't be generated, so moved out from the generated set
  readline = final.callPackage({ buildLuarocksPackage, fetchurl, luaAtLeast, luaOlder, lua, luaposix }:
  buildLuarocksPackage ({
    pname = "readline";
    version = "3.2-0";
    knownRockspec = (fetchurl {
      url    = "mirror://luarocks/readline-3.2-0.rockspec";
      sha256 = "1r0sgisxm4xd1r6i053iibxh30j7j3rcj4wwkd8rzkj8nln20z24";
    }).outPath;
    src = fetchurl {
      # the rockspec url doesn't work because 'www.' is not covered by the certificate so
      # I manually removed the 'www' prefix here
      url    = "http://pjb.com.au/comp/lua/readline-3.2.tar.gz";
      sha256 = "1mk9algpsvyqwhnq7jlw4cgmfzj30l7n2r6ak4qxgdxgc39f48k4";
    };

    luarocksConfig.variables = rec {
      READLINE_INCDIR = "${readline.dev}/include";
      HISTORY_INCDIR = READLINE_INCDIR;
    };
    unpackCmd = ''
      unzip "$curSrc"
      tar xf *.tar.gz
    '';

    propagatedBuildInputs = [
      luaposix
      readline.out
    ];

    meta = {
      homepage = "http://pjb.com.au/comp/lua/readline.html";
      description = "Interface to the readline library";
      license.fullName = "MIT/X11";
      broken = (luaOlder "5.1") || (luaAtLeast "5.5");
    };
  })) {};


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

  tiktoken_core = prev.tiktoken_core.overrideAttrs (oa: {
    cargoDeps = rustPlatform.fetchCargoTarball {
      src = oa.src;
      hash = "sha256-YApsOGfAw34zp069lyGR6FGjxty1bE23+Tic07f8zI4=";
    };
    nativeBuildInputs = oa.nativeBuildInputs ++ [ cargo rustPlatform.cargoSetupHook ];
  });

  toml = prev.toml.overrideAttrs (oa: {
    patches = [ ./toml.patch ];

    nativeBuildInputs = oa.nativeBuildInputs ++ [ tomlplusplus ];
    propagatedBuildInputs = oa.propagatedBuildInputs ++ [ sol2 ];

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "TOML_PLUS_PLUS_SRC" "${tomlplusplus.src}/include/toml++" \
        --replace-fail "MAGIC_ENUM_SRC" "${magic-enum.src}/include/magic_enum"

      cat CMakeLists.txt
    '';
  });

  toml-edit = prev.toml-edit.overrideAttrs (oa: {

    cargoDeps = rustPlatform.fetchCargoTarball {
      src = oa.src;
      hash = "sha256-2P+mokkjdj2PccQG/kAGnIoUPVnK2FqNfYpHPhsp8kw=";
    };

    nativeBuildInputs = oa.nativeBuildInputs ++ [
      cargo
      rustPlatform.cargoSetupHook
      lua.pkgs.luarocks-build-rust-mlua
    ];

  });

  tree-sitter-norg = prev.tree-sitter-norg.overrideAttrs (oa: {
    nativeBuildInputs = let
      # HACK: luarocks-nix doesn't pick up rockspec build dependencies,
      # so we have to pass the correct package in here.
      lua = lib.head oa.propagatedBuildInputs;
    in oa.nativeBuildInputs ++ [
      lua.pkgs.luarocks-build-treesitter-parser
    ] ++ (lib.optionals stdenv.isDarwin [
      clang
      tree-sitter
    ]);
    meta.broken = (luaOlder "5.1" || stdenv.isDarwin);
  });

  vstruct = prev.vstruct.overrideAttrs (_: {
    meta.broken = (luaOlder "5.1" || luaAtLeast "5.4");
  });

  vusted = prev.vusted.overrideAttrs (_: {
    postConfigure = ''
      cat ''${rockspecFilename}
      substituteInPlace ''${rockspecFilename} \
        --replace-fail '"luasystem = 0.2.1",' "'luasystem >= 0.2',"
    '';

    # make sure vusted_entry.vim doesn't get wrapped
    postInstall = ''
      chmod -x $out/bin/vusted_entry.vim
    '';
  });


  # aliases
  cjson = prev.lua-cjson;
}
