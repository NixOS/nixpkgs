{
  stdenv,
  pkgs,
  lib,
  chickenEggs,
}:
let
  inherit (lib) addMetaAttrs;
  addToNativeBuildInputs = pkg: old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ lib.toList pkg;
  };
  addToBuildInputs = pkg: old: {
    buildInputs = (old.buildInputs or [ ]) ++ lib.toList pkg;
  };
  addToPropagatedBuildInputs = pkg: old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ lib.toList pkg;
  };
  addPkgConfig = old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
  };
  addToBuildInputsWithPkgConfig = pkg: old: (addPkgConfig old) // (addToBuildInputs pkg old);
  addToPropagatedBuildInputsWithPkgConfig =
    pkg: old: (addPkgConfig old) // (addToPropagatedBuildInputs pkg old);
  broken = addMetaAttrs { broken = true; };
  brokenOnDarwin = addMetaAttrs { broken = stdenv.hostPlatform.isDarwin; };
  addToCscOptions = opt: old: {
    env.CSC_OPTIONS = lib.concatStringsSep " " ([ old.env.CSC_OPTIONS or "" ] ++ lib.toList opt);
  };
in
{
  breadline = addToBuildInputs pkgs.readline;
  blas = addToBuildInputsWithPkgConfig pkgs.blas;
  blosc = addToBuildInputs pkgs.c-blosc;
  botan = broken;
  cairo =
    old:
    (addToBuildInputsWithPkgConfig pkgs.cairo old)
    // (addToPropagatedBuildInputs (with chickenEggs; [
      srfi-1
      srfi-13
    ]) old);
  cmark = addToBuildInputs pkgs.cmark;
  crypt = addToBuildInputs pkgs.libxcrypt;
  epoxy =
    old:
    (addToPropagatedBuildInputsWithPkgConfig pkgs.libepoxy old)
    // {
      env.NIX_CFLAGS_COMPILE = toString [
        (
          if stdenv.cc.isClang then
            "-Wno-error=incompatible-function-pointer-types"
          else
            "-Wno-error=incompatible-pointer-types"
        )
        "-Wno-error=int-conversion"
      ];
    };
  espeak = addToBuildInputsWithPkgConfig pkgs.espeak-ng;
  ephem = addToBuildInputs pkgs.libnova;
  exif = addToBuildInputsWithPkgConfig pkgs.libexif;
  expat =
    old:
    (addToBuildInputsWithPkgConfig pkgs.expat old)
    // {
      env.NIX_CFLAGS_COMPILE = toString [
        (
          if stdenv.cc.isClang then
            "-Wno-error=incompatible-function-pointer-types"
          else
            "-Wno-error=incompatible-pointer-types"
        )
      ];
    };
  ezxdisp =
    old:
    (addToBuildInputsWithPkgConfig pkgs.libx11 old)
    // {
      env.NIX_CFLAGS_COMPILE = toString [
        "-Wno-error=implicit-function-declaration"
      ];
    };
  freetype = addToBuildInputsWithPkgConfig pkgs.freetype;
  # requires fuse2
  fuse = broken;
  isaac =
    old:
    (addToBuildInputsWithPkgConfig pkgs.libffi old)
    // {
      postPatch = ''
        substituteInPlace rand.h \
          --replace-fail '/*_ randctx *r, word flag _*/' 'randctx *r, word flag' \
          --replace-fail '/*_ randctx *r _*/' 'randctx *r'
      '';
    };
  gl-math = old: {
    env.NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=incompatible-pointer-types"
    ];
  };
  gl-utils = addPkgConfig;
  glfw3 = addToBuildInputsWithPkgConfig pkgs.glfw3;
  glls = addPkgConfig;
  glut =
    old:
    (brokenOnDarwin old)
    // lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) (
      addToCscOptions [
        "-I${(lib.getDev pkgs.libglut)}/include"
        "-I${(lib.getDev pkgs.libGL)}/include"
        "-I${(lib.getDev pkgs.libGLU)}/include"
      ] old
    )
    // (addToBuildInputs pkgs.libglut old);
  hypergiant = addPkgConfig;
  icu = addToBuildInputsWithPkgConfig pkgs.icu;
  imlib2 = addToBuildInputsWithPkgConfig pkgs.imlib2;
  inotify =
    old:
    (addToBuildInputs (lib.optional stdenv.hostPlatform.isDarwin pkgs.libinotify-kqueue) old)
    // lib.optionalAttrs stdenv.hostPlatform.isDarwin (addToCscOptions "-L -linotify" old);
  leveldb = addToBuildInputs pkgs.leveldb;
  libyaml = old: {
    env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";
  };
  lmdb-ht = addToBuildInputs pkgs.lmdb;
  magic = addToBuildInputs pkgs.file;
  magic-pipes = addToBuildInputs pkgs.chickenPackages_5.chickenEggs.regex;
  # requires PCRE
  mdh = broken;
  # missing dependency in upstream egg
  mistie = addToPropagatedBuildInputs (with chickenEggs; [ srfi-1 ]);
  mosquitto = addToPropagatedBuildInputs [ pkgs.mosquitto ];
  mpi =
    old:
    (addToBuildInputs pkgs.openmpi old)
    // {
      preBuild = ''
        mkdir -p $NIX_BUILD_TOP/mpi-dir
        ln -sf ${lib.getDev pkgs.openmpi}/include $NIX_BUILD_TOP/mpi-dir/include
        ln -sf ${lib.getLib pkgs.openmpi}/lib $NIX_BUILD_TOP/mpi-dir/lib
        export MPI_DIR=$NIX_BUILD_TOP/mpi-dir
      '';
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };
  nanomsg = addToBuildInputs pkgs.nanomsg;
  ncurses = addToBuildInputsWithPkgConfig [ pkgs.ncurses ];
  oauthtoothy =
    old:
    (addToPropagatedBuildInputs [ chickenEggs.http-client ] old)
    // {
      postPatch = ''
        sed -i 's/http-curl/http-client/' oauthtoothy.scm oauthtoothy.egg
      '';
    };
  opencl = addToBuildInputs [
    pkgs.opencl-headers
    pkgs.ocl-icd
  ];
  openssl = addToBuildInputs pkgs.openssl;
  plot = addToBuildInputs pkgs.plotutils;
  postgresql = addToBuildInputsWithPkgConfig pkgs.libpq;
  pyffi = addToBuildInputsWithPkgConfig pkgs.python3;
  rocksdb = addToBuildInputs pkgs.rocksdb_8_3;
  # missing dependency in upstream egg
  s9fes-char-graphics-shapes = addToPropagatedBuildInputs (
    with chickenEggs;
    [
      utf8
      s9fes-char-graphics
    ]
  );
  # missing dependency in upstream egg
  s9fes-char-graphics = addToPropagatedBuildInputs (
    with chickenEggs;
    [
      srfi-1
      utf8
      record-variants
    ]
  );
  scheme2c-compatibility = addPkgConfig;
  sdl-base =
    old:
    (
      (addToPropagatedBuildInputsWithPkgConfig pkgs.SDL old)
      //
        # needed for sdl-config to be in PATH
        (addToNativeBuildInputs pkgs.SDL old)
    );
  sdl2 =
    old:
    (
      (addToPropagatedBuildInputsWithPkgConfig pkgs.SDL2 old)
      //
        # needed for sdl2-config to be in PATH
        (addToNativeBuildInputs pkgs.SDL2 old)
    );
  sdl2-image =
    old:
    (
      (addToPropagatedBuildInputsWithPkgConfig pkgs.SDL2_image old)
      //
        # needed for sdl2-config to be in PATH
        (addToNativeBuildInputs pkgs.SDL2 old)
    );
  sdl2-ttf =
    old:
    (
      (addToPropagatedBuildInputsWithPkgConfig pkgs.SDL2_ttf old)
      //
        # needed for sdl2-config to be in PATH
        (addToNativeBuildInputs pkgs.SDL2 old)
    );
  soil = addToPropagatedBuildInputsWithPkgConfig pkgs.libepoxy;
  sqlite3 = addToBuildInputs pkgs.sqlite;
  stemmer = old: (addToBuildInputs pkgs.libstemmer old) // (addToCscOptions "-L -lstemmer" old);
  stfl =
    old: (addToBuildInputs [ pkgs.ncurses pkgs.stfl ] old) // (addToCscOptions "-L -lncurses" old);
  svn-client =
    old:
    (addToBuildInputs [ pkgs.subversion pkgs.aprutil ] old)
    // (addToNativeBuildInputs pkgs.apr old)
    // {
      postPatch =
        let
          svnInclude = "${lib.getDev pkgs.subversion}/include/subversion-1";
          aprUtilInclude = "${lib.getDev pkgs.aprutil}/include";
        in
        ''
          substituteInPlace build-svn-client svn-client.setup \
            --replace-fail '-I/usr/include/subversion-1' "-I${svnInclude}" \
            --replace-fail '-I/usr/local/include/subversion-1' "-I${aprUtilInclude} -I${svnInclude}"
        '';
    };
  taglib =
    old:
    (addToBuildInputs [ pkgs.zlib pkgs.taglib_1 ] old)
    // (
      # needed for tablib-config to be in PATH
      addToNativeBuildInputs pkgs.taglib_1 old
    );
  tokyocabinet =
    old:
    (addToBuildInputs pkgs.tokyocabinet old)
    // {
      env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
    };
  uuid-lib = addToBuildInputs pkgs.libuuid;
  ws-client = addToBuildInputs pkgs.zlib;
  xlib =
    old:
    (addToPropagatedBuildInputs pkgs.libx11 old)
    // {
      env.NIX_CFLAGS_COMPILE = toString [
        (
          if stdenv.cc.isClang then
            "-Wno-error=incompatible-function-pointer-types"
          else
            "-Wno-error=incompatible-pointer-types"
        )
      ];
    };
  yaml = addToBuildInputs pkgs.libyaml;
  zlib = addToBuildInputs pkgs.zlib;
  zmq = addToBuildInputs pkgs.zeromq;
  zstd = addToBuildInputs pkgs.zstd;

  # less trivial fixes, should be upstreamed
  git =
    old:
    (addToBuildInputsWithPkgConfig pkgs.libgit2 old)
    // {
      postPatch = ''
        substituteInPlace libgit2.scm \
          --replace-fail "asize" "reserved"
      '';
    };
  lazy-ffi = old: (addToBuildInputs pkgs.libffi old);
  opengl =
    old:
    (brokenOnDarwin old)
    // (addToBuildInputsWithPkgConfig (lib.optionals (!stdenv.hostPlatform.isDarwin) [
      pkgs.libGL
      pkgs.libGLU
    ]) old);
  posix-shm = old: {
    postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace build.scm \
        --replace "-lrt" ""
    '';
  };

  # platform changes
  pledge = addMetaAttrs { platforms = lib.platforms.openbsd; };
  unveil = addMetaAttrs { platforms = lib.platforms.openbsd; };

  # overrides for chicken 5.4
  dbus =
    old:
    (addToBuildInputsWithPkgConfig [ pkgs.dbus ] old)
    // {
      # backticks in compiler options
      # aren't supported anymore as of chicken 5.4, it seems.
      preBuild = ''
        substituteInPlace \
          dbus.egg dbus.setup \
          --replace-fail '`pkg-config --cflags dbus-1`' "$(pkg-config --cflags dbus-1)" \
          --replace-fail '`pkg-config --libs dbus-1`' "$(pkg-config --libs dbus-1)"
      '';
    };
  math = old: {
    # define-values is used but not imported
    # some breaking change happened now it needs to be done
    # explicitly?
    preBuild = ''
      substituteInPlace *.scm **/*.scm \
        --replace-quiet 'only chicken.base' 'only chicken.base define-values'
    '';
  };
  raylib = addToBuildInputsWithPkgConfig pkgs.raylib;
  socket = old: {
    # chicken-do checks for changes to a file that doesn't exist
    preBuild = ''
      touch socket-config
    '';
  };

  # mark broken
  allegro =
    old:
    (broken old)
    // {
      # depends on 'chicken' egg, which doesn't exist, so we specify all the deps here (needs to be
      # kept around even when marked as broken so that evaluation doesn't break due to the missing
      # attribute).
      propagatedBuildInputs = [
        chickenEggs.foreigners
      ];
    };
  canvas-draw = broken;
  gemini = broken;
  gemini-client = broken;
  iup = broken;
  kiwi = broken;
  qt-light = broken;
  sundials = broken;
  # webkitgtk_4_0 was removed
  webview = broken;

  # mark broken darwin

  # The last successful Darwin Hydra build was in 2024
  iconv = brokenOnDarwin;
  # fatal error: 'mqueue.h' file not found
  posix-mq = brokenOnDarwin;
  # Undefined symbols for architecture arm64: "_pthread_setschedprio"
  pthreads = brokenOnDarwin;
  # error: use of undeclared identifier 'B4000000'
  stty = brokenOnDarwin;
}
