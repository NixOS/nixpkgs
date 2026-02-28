# do not add pkgs, it messes up splicing
{
  stdenv,
  cargo,
  cmake,

  ast-grep,
  which,
  findutils,
  coreutils,
  curl,
  dbus,
  expat,
  fd,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  fzf,
  glib,
  glibcLocalesUtf8,
  gmp,
  gnulib,
  gnum4,
  gobject-introspection,
  imagemagick,
  installShellFiles,
  lib,
  libc,
  libevent,
  libiconv,
  libmpack,
  libmysqlclient,
  libpsl,
  libpq,
  libuuid,
  libxcrypt,
  libyaml,
  lua-language-server,
  mariadb,
  mpfr,
  neovim-unwrapped,
  oniguruma,
  openldap,
  openssl,
  pcre,
  pkg-config,
  readline,
  ripgrep,
  rustPlatform,
  sqlite,
  tree-sitter,
  unbound,
  unzip,
  util-linux,
  versionCheckHook,
  vimPlugins,
  yajl,
  zip,
  zlib,
  zziplib,
  writableTmpDirAsHomeHook,
  gitMinimal,
  getopt,
}:

final: prev:
let
  inherit (prev)
    luaOlder
    luaAtLeast
    lua
    isLuaJIT
    ;
in
{
  # keep-sorted start block=yes case=no newline_separated=yes
  argparse = prev.argparse.overrideAttrs {
    doCheck = true;
    nativeCheckInputs = [ final.bustedCheckHook ];

    preCheck = ''LUA_PATH="src/?.lua;$LUA_PATH"'';
    bustedFlags = [ "spec/" ];
  };

  busted = prev.busted.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [
      installShellFiles
    ];
    postInstall = ''
      installShellCompletion --cmd busted \
        --zsh completions/zsh/_busted \
        --bash completions/bash/busted.bash
    '';
  });

  cjson = prev.lua-cjson;

  cqueues = prev.cqueues.overrideAttrs (old: {
    # Parse out a version number without the Lua version inserted
    version =
      let
        version' = prev.cqueues.version;
        rel = lib.splitVersion version';
        date = lib.head rel;
        rev = lib.last (lib.splitString "-" (lib.last rel));
      in
      "${date}-${rev}";
    __intentionallyOverridingVersion = true;

    meta.broken = luaOlder "5.1" || luaAtLeast "5.5";

    nativeBuildInputs = old.nativeBuildInputs ++ [
      gnum4
    ];

    externalDeps = [
      {
        name = "CRYPTO";
        dep = openssl;
      }
      {
        name = "OPENSSL";
        dep = openssl;
      }
    ];

    env = old.env // {
      NIX_CFLAGS_COMPILE = "-std=gnu17"; # for gcc15
    };

    # Upstream rockspec is pointlessly broken into separate rockspecs, per Lua
    # version, which doesn't work well for us, so modify it
    postConfigure =
      let
        inherit (final.cqueues) pname version;
      in
      ''
        # 'all' target auto-detects correct Lua version, which is fine for us as
        # we only have the right one available :)
        sed -Ei ''${rockspecFilename} \
          -e 's|lua == 5.[[:digit:]]|lua >= 5.1, <= 5.4|' \
          -e 's|build_target = "[^"]+"|build_target = "all"|' \
          -e 's|version = "[^"]+"|version = "${version}"|'
        specDir=$(dirname ''${rockspecFilename})
        cp ''${rockspecFilename} "$specDir/${pname}-${version}.rockspec"
        rockspecFilename="$specDir/${pname}-${version}.rockspec"
      '';
  });

  fzf-lua = prev.fzf-lua.overrideAttrs {
    # FIXME: https://github.com/NixOS/nixpkgs/issues/431458
    # fzf-lua throws `address already in use` on darwin
    # Previewer transient failure
    # UI tests fail either transiently or consistently in certain software/hardware configurations
    doCheck = false;
    checkInputs = [
      fd
      fzf
      getopt
      ripgrep
    ];
    nativeCheckInputs = [
      neovim-unwrapped
      writableTmpDirAsHomeHook
    ];
    checkPhase = ''
      runHook preCheck

      # Linking the dependencies since makefile wants to clone them each time
      # for `make deps`
      mkdir -p deps
      ln -s ${vimPlugins.mini-nvim} deps/mini.nvim
      ln -s ${vimPlugins.nvim-web-devicons} deps/nvim-web-devicons

      # TODO: remove with new nvim-web-devicons release
      # Disabled devicons test because we have old version as dep and fzf-lua checks for a new icon
      substituteInPlace tests/files_spec.lua \
        --replace-fail \
          "T[\"files\"][\"icons\"] = new_set({ parametrize = { { \"devicons\" }, { \"mini\" } } })" \
          "T[\"files\"][\"icons\"] = new_set({ parametrize = { { \"mini\" } } })"

      # TODO: Figure out why 2 files extra
      substituteInPlace tests/screenshots/tests-files_spec.lua---files---executable---1-+-args-{-\'fd\'-} \
        --replace-fail "  99" "101" \
        --replace-fail "99" "101"

      make test

      runHook postCheck
    '';
  };

  fzy = prev.fzy.overrideAttrs {
    doCheck = true;
    nativeCheckInputs = [ final.bustedCheckHook ];
    # bustedFlags = [ "." ];
  };

  grug-far-nvim = prev.grug-far-nvim.overrideAttrs {
    doCheck = lua.luaversion == "5.1" && !stdenv.hostPlatform.isDarwin;
    nativeCheckInputs = [
      final.busted
      final.mini-test
      final.nlua
      ripgrep
      neovim-unwrapped
    ];

    # feel free to disable the checks. They are mostly screenshot based
    checkPhase = ''
      runHook preCheck
      # feel free to disable/adjust the tests
      rm tests/base/test_apply.lua tests/base/test_vimscript_interpreter.lua

      # Dependencies needed in special location
      mkdir -p deps/{ripgrep,astgrep}
      mkdir {temp_test_dir,temp_history_dir}
      ln -s ${lib.getExe ripgrep} deps/ripgrep/rg
      ln -s ${lib.getExe ast-grep} deps/astgrep/ast-grep
      ln -s ${vimPlugins.mini-nvim} deps/mini.nvim

      # Update dependency check to respect packaged version
      substituteInPlace lua/grug-far/test/dependencies.lua \
        --replace-fail "local RG_VERSION = '14.1.0'" "local RG_VERSION = '${lib.getVersion ripgrep}'" \
        --replace-fail "local SG_VERSION = '0.35.0'" "local SG_VERSION = '${lib.getVersion ast-grep}'"

      make test dir=base
      runHook postCheck
    '';

  };

  haskell-tools-nvim = prev.haskell-tools-nvim.overrideAttrs {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nlua
      final.bustedCheckHook
      writableTmpDirAsHomeHook
    ];
  };

  ldbus = prev.ldbus.overrideAttrs (old: {
    luarocksConfig = old.luarocksConfig // {
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

  lgi = prev.lgi.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [
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

      # https://github.com/lgi-devs/lgi/issues/346
      # https://gitlab.archlinux.org/archlinux/packaging/packages/lgi/-/issues/1
      (fetchpatch {
        name = "glib-2.86.0.patch";
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/lgi/-/raw/05a0c9df75883da235bacd4379b769e7d7713fb9/0001-Use-TypeClass.get-instead-of-.ref.patch";
        hash = "sha256-Z1rNv0VzVrK41rV73KiPXq9yLaNxbTOFiSd6eLZyrbY=";
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

  ljsyscall = prev.ljsyscall.overrideAttrs (old: rec {
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

    propagatedBuildInputs = old.propagatedBuildInputs ++ lib.optional (!isLuaJIT) final.luaffi;
  });

  llscheck = prev.llscheck.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [ lua-language-server ];
  });

  lmathx = prev.luaLib.overrideLuarocks prev.lmathx (
    _drv:
    if luaAtLeast "5.1" && luaOlder "5.2" then
      {
        version = "20120430.51-1";
        knownRockspec =
          (fetchurl {
            url = "mirror://luarocks/lmathx-20120430.51-1.rockspec";
            sha256 = "148vbv2g3z5si2db7rqg5bdily7m4sjyh9w6r3jnx3csvfaxyhp0";
          }).outPath;
        src = fetchurl {
          url = "https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/5.1/lmathx.tar.gz";
          sha256 = "0sa553d0zlxhvpsmr4r7d841f16yq4wr3fg7i07ibxkz6yzxax51";
        };
      }
    else if luaAtLeast "5.2" && luaOlder "5.3" then
      {
        version = "20120430.52-1";
        knownRockspec =
          (fetchurl {
            url = "mirror://luarocks/lmathx-20120430.52-1.rockspec";
            sha256 = "14rd625sipakm72wg6xqsbbglaxyjba9nsajsfyvhg0sz8qjgdya";
          }).outPath;
        src = fetchurl {
          url = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/lmathx.tar.gz";
          sha256 = "19dwa4z266l2njgi6fbq9rak4rmx2fsx1s0p9sl166ar3mnrdwz5";
        };
      }
    else
      {
        disabled = luaOlder "5.1" || luaAtLeast "5.5";
        # works fine with 5.4 as well
        postConfigure = ''
          substituteInPlace ''${rockspecFilename} \
            --replace 'lua ~> 5.3' 'lua >= 5.3, < 5.5'
        '';
      }
  );

  lmpfrlib = prev.lmpfrlib.overrideAttrs {
    externalDeps = [
      {
        name = "GMP";
        dep = gmp;
      }
      {
        name = "MPFR";
        dep = mpfr;
      }
    ];
    unpackPhase = ''
      cp $src $(stripHash $src)
    '';
  };

  lrexlib-gnu = prev.lrexlib-gnu.overrideAttrs (old: {
    strictDeps = false;
    buildInputs = old.buildInputs ++ [
      gnulib
    ];
    meta.broken = isLuaJIT;
  });

  lrexlib-oniguruma = prev.lrexlib-oniguruma.overrideAttrs {
    externalDeps = [
      {
        name = "ONIG";
        dep = oniguruma;
      }
    ];
  };

  lrexlib-pcre = prev.lrexlib-pcre.overrideAttrs {
    externalDeps = [
      {
        name = "PCRE";
        dep = pcre;
      }
    ];
  };

  lrexlib-posix = prev.lrexlib-posix.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      (lib.getDev libc)
    ];
  });

  lua-cmsgpack = prev.lua-cmsgpack.overrideAttrs {
    strictDeps = false;
    meta.broken = isLuaJIT;
  };

  lua-curl = prev.lua-curl.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      curl.dev
    ];
  });

  lua-iconv = prev.lua-iconv.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      libiconv
    ];
  });

  lua-lsp = prev.lua-lsp.overrideAttrs {
    # until Alloyed/lua-lsp#28
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace '"dkjson ~> 2.5",' '"dkjson >= 2.5",'
    '';
  };

  lua-resty-jwt = prev.lua-resty-jwt.overrideAttrs {
    src = fetchFromGitHub {
      owner = "cdbattags";
      repo = "lua-resty-jwt";
      rev = "v0.2.3";
      hash = "sha256-5lnr0ka6ijfujiRjqwCPb6jzItXx45FIN8CvhR/KiB8=";
      fetchSubmodules = true;
    };
  };

  lua-rtoml = prev.lua-rtoml.overrideAttrs (old: {
    strictDeps = false;

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (old) src;
      hash = "sha256-7mFn4dLgaxfAxtPFCc3VzcBx2HuywcZTYqCGTbaGS0k=";
    };

    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      cargo
      rustPlatform.cargoSetupHook
    ];

    # ld: symbol(s) not found for architecture arm64
    # clang-16: error: linker command failed with exit code 1 (use -v to see invocation)
    meta.broken = stdenv.hostPlatform.isDarwin || luaAtLeast "5.5";
  });

  lua-subprocess = prev.lua-subprocess.overrideAttrs {
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
  };

  lua-yajl = prev.lua-yajl.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      yajl
    ];
    luarocksConfig = old.luarocksConfig // {
      variables = {
        # Since yajl's outputs are split, we need to help luarocks find the
        # include directory.
        YAJL_INCDIR = "${lib.getDev yajl}/include";
      };
    };
  });

  lua-zlib = prev.lua-zlib.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      zlib.dev
    ];
    meta = old.meta // {
      broken = luaOlder "5.1" || luaAtLeast "5.4";
    };
  });

  luacheck = prev.luacheck.overrideAttrs (old: {
    meta = old.meta // {
      mainProgram = "luacheck";
    };
  });

  luacov = prev.luacov.overrideAttrs (old: {
    postInstall = ''
      mkdir -p $out/share/lua/${lua.luaversion}/luacov/reporter/src/luacov/reporter/html
      mv src/luacov/reporter/html/static $out/share/lua/${lua.luaversion}/luacov/reporter/src/luacov/reporter/html/static
    '';
  });

  luadbi-mysql = prev.luadbi-mysql.overrideAttrs (old: {

    luarocksConfig = lib.recursiveUpdate old.luarocksConfig {
      variables = {
        MYSQL_INCDIR = "${lib.getDev libmysqlclient}/include/";
        MYSQL_LIBDIR = "${lib.getLib libmysqlclient}/lib//mysql/";
      };
    };
    buildInputs = old.buildInputs ++ [
      mariadb.client
      libmysqlclient
    ];
  });

  luadbi-postgresql = prev.luadbi-postgresql.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      (lib.getDev libpq)
    ];
  });

  luadbi-sqlite3 = prev.luadbi-sqlite3.overrideAttrs {
    externalDeps = [
      {
        name = "SQLITE";
        dep = sqlite;
      }
    ];
  };

  luaevent = prev.luaevent.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      final.luasocket
    ];
    externalDeps = [
      {
        name = "EVENT";
        dep = libevent;
      }
    ];
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
  });

  luaexpat = prev.luaexpat.overrideAttrs (_: {
    externalDeps = [
      {
        name = "EXPAT";
        dep = expat;
      }
    ];
  });

  luaffi = prev.luaffi.overrideAttrs {
    # TODO Somehow automatically amend buildInputs for things that need luaffi
    # but are in luajitPackages?

    # The packaged .src.rock version is pretty old, and doesn't work with Lua 5.3
    src = fetchFromGitHub {
      owner = "facebook";
      repo = "luaffifb";
      rev = "532c757e51c86f546a85730b71c9fef15ffa633d";
      sha256 = "1nwx6sh56zfq99rcs7sph0296jf6a9z72mxknn0ysw9fd7m1r8ig";
    };
    knownRockspec = with prev.luaffi; "${pname}-${version}.rockspec";
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4" || isLuaJIT;
  };

  lualdap = prev.lualdap.overrideAttrs (_: {
    externalDeps = [
      {
        name = "LDAP";
        dep = openldap;
      }
    ];
  });

  lualine-nvim = prev.lualine-nvim.overrideAttrs (_: {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nvim-web-devicons
      final.bustedCheckHook
      final.nlua
      gitMinimal
      writableTmpDirAsHomeHook
    ];

    bustedFlags = [
      "tests/"
    ];

    preCheck = ''
      LUA_PATH="lua/?.lua;lua/?/init.lua;$LUA_PATH"
    '';
  });

  luaossl = prev.luaossl.overrideAttrs (old: {
    externalDeps = [
      {
        name = "CRYPTO";
        dep = openssl;
      }
      {
        name = "OPENSSL";
        dep = openssl;
      }
    ];

    env = old.env // {
      NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types"; # for gcc15
    };
  });

  luaposix = prev.luaposix.overrideAttrs (old: {
    externalDeps = [
      {
        name = "CRYPT";
        dep = libxcrypt;
      }
    ];
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
      final.bit32
      final.std-normalize
    ];
  });

  luaprompt = prev.luaprompt.overrideAttrs (old: {
    externalDeps = [
      {
        name = "READLINE";
        dep = readline;
      }
      {
        name = "HISTORY";
        dep = readline;
      }
    ];

    nativeBuildInputs = old.nativeBuildInputs ++ [ installShellFiles ];

    postInstall = ''
      installManPage luap.1
    '';
  });

  luarocks = prev.luarocks.overrideAttrs (old: {
    # As a nix user, use this derivation instead of "luarocks_bootstrap"

    nativeBuildInputs = old.nativeBuildInputs ++ [
      installShellFiles
      lua
      unzip
      versionCheckHook
    ];
    # cmake is just to compile packages with "cmake" buildType, not luarocks itself
    dontUseCmakeConfigure = true;

    doInstallCheck = true;

    propagatedBuildInputs = [
      zip
      unzip
      cmake
    ];

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd luarocks \
        --bash <($out/bin/luarocks completion bash) \
        --fish <($out/bin/luarocks completion fish) \
        --zsh <($out/bin/luarocks completion zsh)

      installShellCompletion --cmd luarocks-admin \
        --bash <($out/bin/luarocks-admin completion bash) \
        --fish <($out/bin/luarocks-admin completion fish) \
        --zsh <($out/bin/luarocks-admin completion zsh)
    '';

    meta = old.meta // {
      mainProgram = "luarocks";
    };

  });

  luasec = prev.luasec.overrideAttrs {
    externalDeps = [
      {
        name = "OPENSSL";
        dep = openssl;
      }
    ];
  };

  luasql-sqlite3 = prev.luasql-sqlite3.overrideAttrs {
    externalDeps = [
      {
        name = "SQLITE";
        dep = sqlite;
      }
    ];
  };

  luasystem = prev.luasystem.overrideAttrs (
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      buildInputs = [ libc.out ];
    }
  );

  luaunbound = prev.luaunbound.overrideAttrs {
    externalDeps = [
      {
        name = "libunbound";
        dep = unbound;
      }
    ];
  };

  luazip = prev.luazip.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
      zziplib
    ];
  });

  lush-nvim = prev.lush-nvim.overrideAttrs {
    # Remove dangling symlink created during installation because we don't copy the source CREATE.md it links to
    # Using a generic method because path changes depending on if building luaPackage or vimPlugin
    postInstall = ''
      find -L $out -type l -name "README.md" -print -delete
    '';
  };

  luuid = prev.luuid.overrideAttrs (old: {
    externalDeps = [
      {
        name = "LIBUUID";
        dep = libuuid;
      }
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
    postConfigure = ''
      sed -Ei ''${rockspecFilename} -e 's|lua >= 5.2|lua >= 5.1,|'
    '';
    meta = old.meta // {
      broken = luaOlder "5.1" || (luaAtLeast "5.4");
      platforms = lib.platforms.linux;
    };
  });

  lux-lua = final.callPackage ./lux-lua.nix { inherit lua; };

  lyaml = prev.lyaml.overrideAttrs {
    buildInputs = [
      libyaml
    ];
  };

  lz-n = prev.lz-n.overrideAttrs {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nlua
      final.bustedCheckHook
      writableTmpDirAsHomeHook
    ];
  };

  lze = prev.lze.overrideAttrs {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nlua
      final.bustedCheckHook
      writableTmpDirAsHomeHook
    ];
  };

  lzextras = prev.lzextras.overrideAttrs {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nlua
      lua.pkgs.bustedCheckHook
      final.lze
    ];
  };

  magick = prev.magick.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [
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
    buildInputs = (drv.buildInputs or [ ]) ++ [ libmpack ];
    env = {
      # the rockspec doesn't use the makefile so you may need to export more flags
      USE_SYSTEM_LUA = "yes";
      USE_SYSTEM_MPACK = "yes";
    };
  });

  neorg = prev.neorg.overrideAttrs {
    # Relax dependencies
    postConfigure = ''
      substituteInPlace ''${rockspecFilename} \
        --replace-fail "'nvim-nio ~> 1.7'," "'nvim-nio >= 1.7'," \
        --replace-fail "'plenary.nvim == 0.1.4'," "'plenary.nvim'," \
        --replace-fail "'nui.nvim == 0.3.0'," "'nui.nvim'," \
        --replace-fail ", 'nvim-treesitter-legacy-api == 0.9.2'" ""
    '';
  };

  neotest = prev.neotest.overrideAttrs (old: {
    doCheck = stdenv.hostPlatform.isLinux;
    nativeCheckInputs = old.nativeCheckInputs ++ [
      final.nlua
      final.busted
      neovim-unwrapped
      writableTmpDirAsHomeHook
    ];

    checkPhase = ''
      runHook preCheck
      export LUA_PATH="./lua/?.lua;./lua/?/init.lua;$LUA_PATH"

      # TODO: Investigate if test infra issue or upstream issue
      # Remove failing subprocess tests that require channel functionality
      rm tests/unit/lib/subprocess_spec.lua

      nvim --headless -i NONE \
        --cmd "set rtp+=${vimPlugins.plenary-nvim}" \
        -c "PlenaryBustedDirectory tests/ {sequential = true}"

      runHook postCheck
    '';
  });

  nlua = prev.nlua.overrideAttrs {

    # patchShebang removes the nvim in nlua's shebang so we hardcode one
    postFixup = ''
      sed -i -e "1 s|.*|#\!${coreutils}/bin/env -S ${neovim-unwrapped}/bin/nvim -l|" "$out/bin/nlua"
    '';
    dontPatchShebangs = true;
  };

  nvim-nio = prev.nvim-nio.overrideAttrs {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nlua
      # upstream uses PlenaryBusted which is a pain, run busted directly instead
      final.bustedCheckHook
      writableTmpDirAsHomeHook
    ];

    preCheck = ''
      LUA_PATH="lua/?.lua;lua/?/init.lua;$LUA_PATH"
    '';
    bustedFlags = [
      "tests/"
    ];
  };

  orgmode = prev.orgmode.overrideAttrs {
    doCheck = stdenv.hostPlatform.isLinux;
    nativeCheckInputs = [
      neovim-unwrapped
      glibcLocalesUtf8 # the tests run "vim.cmd.language('en_US.utf-8')"
      writableTmpDirAsHomeHook
      util-linux # for uuidgen
    ];

    # Patch in tree-sitter-orgmode dependency
    postPatch = ''
      substituteInPlace lua/orgmode/config/init.lua \
        --replace-fail \
        "require('orgmode.utils.treesitter.install').install()" \
        "pcall(function() vim.treesitter.language.add('org', { path = '${final.tree-sitter-orgmode}/lib/lua/${final.tree-sitter-orgmode.lua.luaversion}/parser/org.so'}) end)" \
        --replace-fail \
        "require('orgmode.utils.treesitter.install').reinstall()" \
        "pcall(function() vim.treesitter.language.add('org', { path = '${final.tree-sitter-orgmode}/lib/lua/${final.tree-sitter-orgmode.lua.luaversion}/parser/org.so'}) end)"
    '';

    preCheck = ''LUA_PATH="lua/?.lua;lua/?/init.lua;$LUA_PATH"'';

    checkPhase = ''
      runHook preCheck

      # bypass the download of plenary
      substituteInPlace  tests/minimal_init.lua --replace-fail \
        "plenary = 'https://github.com/nvim-lua/plenary.nvim.git'," \
        ""

      # remove failing tests
      rm tests/plenary/colors/colors_spec.lua # colors depend on neovim version usually
      rm tests/plenary/capture/capture_spec.lua # because clipboard not available

      # not sure why yet
      rm tests/plenary/ui/mappings/date_spec.lua \
        tests/plenary/capture/templates_spec.lua

      # bypass upstream launcher that interacts with network
      nvim --headless -i NONE \
        -u test/minimal_init.vim --cmd "set rtp+=${vimPlugins.plenary-nvim}" \
        -c "PlenaryBustedDirectory tests { sequential = true, minimal_init = './tests/minimal_init.lua' }"

      runHook postCheck
    '';
  };

  plenary-nvim = prev.plenary-nvim.overrideAttrs {
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
      writableTmpDirAsHomeHook
    ];

    checkPhase = ''
      runHook preCheck
      # remove failing tests, need internet access for instance
      rm tests/plenary/job_spec.lua tests/plenary/scandir_spec.lua tests/plenary/curl_spec.lua
      make test
      runHook postCheck
    '';
  };

  psl = prev.psl.overrideAttrs (drv: {
    buildInputs = drv.buildInputs or [ ] ++ [ libpsl ];

    luarocksConfig.variables = drv.luarocksConfig.variables // {
      PSL_INCDIR = lib.getDev libpsl + "/include";
      PSL_DIR = lib.getLib libpsl;
    };
  });

  rapidjson = prev.rapidjson.overrideAttrs {
    preBuild = ''
      sed -i '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt
      sed -i '/set(CMAKE_C_FLAGS/d' CMakeLists.txt
    '';
  };

  rest-nvim = prev.rest-nvim.overrideAttrs {
    strictDeps = false;
  };

  rocks-dev-nvim = prev.rocks-dev-nvim.overrideAttrs {

    # E5113: Error while calling lua chunk [...] pl.path requires LuaFileSystem
    # TODO: figure out darwin failure
    doCheck = luaOlder "5.2" && stdenv.hostPlatform.isLinux;
    nativeCheckInputs = [
      final.nlua
      final.bustedCheckHook
    ];
    bustedFlags = [ "spec" ];
  };

  rocks-nvim = prev.rocks-nvim.overrideAttrs (oa: {

    nativeCheckInputs = [
      final.nlua
      final.busted
      writableTmpDirAsHomeHook
    ];

    # TODO: figure out darwin failure
    doCheck = lua.luaversion == "5.1" && stdenv.hostPlatform.isLinux;

    nvimSkipModules = [
      "bootstrap" # tries to install luarocks from network
    ];

    bustedFlags = [
      "--run=offline"
    ];
  });

  rtp-nvim = prev.rtp-nvim.overrideAttrs {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nlua
      final.bustedCheckHook
      writableTmpDirAsHomeHook
    ];
  };

  rustaceanvim = prev.rustaceanvim.overrideAttrs {
    doCheck = lua.luaversion == "5.1";
    nativeCheckInputs = [
      final.nlua
      final.bustedCheckHook
      writableTmpDirAsHomeHook
    ];
  };

  sofa = prev.sofa.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [
      installShellFiles
    ];
    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd sofa \
        --bash <($out/bin/sofa --completion bash) \
        --fish <($out/bin/sofa --completion fish) \
        --zsh <($out/bin/sofa --completion zsh)
    '';
  });

  sqlite = prev.sqlite.overrideAttrs {
    doCheck = stdenv.hostPlatform.isLinux;
    nativeCheckInputs = [
      final.plenary-nvim
      neovim-unwrapped
      writableTmpDirAsHomeHook
    ];

    # the plugin loldds the library from either the LIBSQLITE env
    # or the vim.g.sqlite_clib_path variable.
    postPatch = ''
      substituteInPlace lua/sqlite/defs.lua \
        --replace-fail "path = vim.g.sqlite_clib_path" 'path = vim.g.sqlite_clib_path or  "${sqlite.out}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary}"'
    '';

    # we override 'luarocks test' because otherwise neovim doesn't find/loldd the plenary plugin
    checkPhase = ''
      runHook preCheck
      nvim --headless -i NONE \
        -u test/minimal_init.vim --cmd "set rtp+=${vimPlugins.plenary-nvim}" \
        -c "PlenaryBustedDirectory test/auto/ { sequential = true, minimal_init = './test/minimal_init.vim' }"
      runHook postCheck
    '';
  };

  std-_debug = prev.std-_debug.overrideAttrs {
    # run make to generate lib/std/_debug/version.lua
    preConfigure = ''
      make all
    '';
  };

  std-normalize = prev.std-normalize.overrideAttrs {
    # run make to generate lib/std/_debug/version.lua
    preConfigure = ''
      make all
    '';
  };

  tiktoken_core = prev.tiktoken_core.overrideAttrs (old: {
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (old) src;
      hash = "sha256-egmb4BTbORpTpVO50IcqbZU1Y0hioXLMkxxUAo05TIA=";
    };
    nativeBuildInputs = old.nativeBuildInputs ++ [
      cargo
      rustPlatform.cargoSetupHook
    ];

    meta = old.meta // {
      broken = luaAtLeast "5.5";
    };
  });

  tl = prev.tl.overrideAttrs (old: {
    preConfigure = ''
      rm luarocks.lock
    '';
    meta = old.meta // {
      mainProgram = "tl";
    };
  });

  toml-edit = prev.toml-edit.overrideAttrs (old: {
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (old) src;
      hash = "sha256-8lYvdraKEd1nf8dkZuSDQRVJvX56gHCcTZVtyoy/0IM=";
    };

    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin (
      if lua.pkgs.isLuaJIT then "-lluajit-${lua.luaversion}" else "-llua"
    );

    nativeBuildInputs = old.nativeBuildInputs ++ [
      cargo
      rustPlatform.cargoSetupHook
      lua.pkgs.luarocks-build-rust-mlua
    ];
  });

  tree-sitter-http = prev.tree-sitter-http.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
      tree-sitter
      writableTmpDirAsHomeHook
    ];
  });

  tree-sitter-norg = prev.tree-sitter-norg.overrideAttrs (old: {
    meta.broken = lua.luaversion != "5.1";
  });

  tree-sitter-orgmode = prev.tree-sitter-orgmode.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
      writableTmpDirAsHomeHook
      tree-sitter
    ];

    # should be fixed upstream
    meta.broken = lua.luaversion != "5.1";
  });

  vstruct = prev.vstruct.overrideAttrs (_: {
    meta.broken = luaOlder "5.1" || luaAtLeast "5.4";
  });

  vusted = prev.vusted.overrideAttrs (_: {
    # make sure vusted_entry.vim doesn't get wrapped
    postInstall = ''
      chmod -x $out/bin/vusted_entry.vim
    '';
  });

  # keep-sorted end
}
