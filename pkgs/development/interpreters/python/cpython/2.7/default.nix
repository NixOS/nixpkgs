{ lib, stdenv, fetchFromGitHub, fetchpatch
, bzip2
, expat
, libffi
, gdbm
, db
, ncurses
, openssl
, readline
, sqlite
, tcl ? null, tk ? null, tix ? null, libX11 ? null, x11Support ? false
, zlib
, self
, configd, coreutils
, autoreconfHook
, python-setup-hook
# Some proprietary libs assume UCS2 unicode, especially on darwin :(
, ucsEncoding ? 4
# For the Python package set
, packageOverrides ? (self: super: {})
, pkgsBuildBuild
, pkgsBuildHost
, pkgsBuildTarget
, pkgsHostHost
, pkgsTargetTarget
, sourceVersion
, sha256
, passthruFun
, static ? stdenv.hostPlatform.isStatic
, stripBytecode ? reproducibleBuild
, rebuildBytecode ? true
, reproducibleBuild ? false
, enableOptimizations ? false
, strip2to3 ? false
, stripConfig ? false
, stripIdlelib ? false
, stripTests ? false
, stripLibs ? [ ]
, pythonAttr ? "python${sourceVersion.major}${sourceVersion.minor}"
}:

assert x11Support -> tcl != null
                  && tk != null
                  && libX11 != null;

assert lib.assertMsg (enableOptimizations -> (!stdenv.cc.isClang))
  "Optimizations with clang are not supported. configure: error: llvm-profdata is required for a --enable-optimizations build but could not be found.";

assert lib.assertMsg (reproducibleBuild -> stripBytecode)
  "Deterministic builds require stripping bytecode.";

assert lib.assertMsg (reproducibleBuild -> (!enableOptimizations))
  "Deterministic builds are not achieved when optimizations are enabled.";

assert lib.assertMsg (reproducibleBuild -> (!rebuildBytecode))
  "Deterministic builds are not achieved when (default unoptimized) bytecode is created.";

with lib;

let
  buildPackages = pkgsBuildHost;
  inherit (passthru) pythonForBuild;

  pythonForBuildInterpreter = if stdenv.hostPlatform == stdenv.buildPlatform then
    "$out/bin/python"
  else pythonForBuild.interpreter;

  passthru = passthruFun rec {
    inherit self sourceVersion packageOverrides;
    implementation = "cpython";
    libPrefix = "python${pythonVersion}";
    executable = libPrefix;
    pythonVersion = with sourceVersion; "${major}.${minor}";
    sitePackages = "lib/${libPrefix}/site-packages";
    inherit hasDistutilsCxxPatch pythonAttr;
    pythonOnBuildForBuild = pkgsBuildBuild.${pythonAttr};
    pythonOnBuildForHost = pkgsBuildHost.${pythonAttr};
    pythonOnBuildForTarget = pkgsBuildTarget.${pythonAttr};
    pythonOnHostForHost = pkgsHostHost.${pythonAttr};
    pythonOnTargetForTarget = pkgsTargetTarget.${pythonAttr} or {};
  } // {
    inherit ucsEncoding;
  };

  version = with sourceVersion; "${major}.${minor}.${patch}${suffix}";

  # ActiveState is a fork of cpython that includes fixes for security
  # issues after its EOL
  src = fetchFromGitHub {
    owner = "ActiveState";
    repo = "cpython";
    rev = "v${version}";
    inherit sha256;
  };

  hasDistutilsCxxPatch = !(stdenv.cc.isGNU or false);
  patches =
    [ # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
      ./search-path.patch

      # Python recompiles a Python if the mtime stored *in* the
      # pyc/pyo file differs from the mtime of the source file.  This
      # doesn't work in Nix because Nix changes the mtime of files in
      # the Nix store to 1.  So treat that as a special case.
      ./nix-store-mtime.patch

      # patch python to put zero timestamp into pyc
      # if DETERMINISTIC_BUILD env var is set
      ./deterministic-build.patch

      # Fix python bug #27177 (https://bugs.python.org/issue27177)
      # The issue is that `match.group` only recognizes python integers
      # instead of everything that has `__index__`.
      # This bug was fixed upstream, but not backported to 2.7
      (fetchpatch {
        name = "re_match_index.patch";
        url = "https://bugs.python.org/file43084/re_match_index.patch";
        sha256 = "0l9rw6r5r90iybdkp3hhl2pf0h0s1izc68h5d3ywrm92pq32wz57";
      })

      # Fix race-condition during pyc creation. Has a slight backwards
      # incompatible effect: pyc symlinks will now be overridden
      # (https://bugs.python.org/issue17222). Included in python >= 3.4,
      # backported in debian since 2013.
      # https://bugs.python.org/issue13146
      ./atomic_pyc.patch

      # Backport from CPython 3.8 of a good list of tests to run for PGO.
      ./profile-task.patch

      # The workaround is for unittests on Win64, which we don't support.
      # It does break aarch64-darwin, which we do support. See:
      # * https://bugs.python.org/issue35523
      # * https://github.com/python/cpython/commit/e6b247c8e524
      ../3.7/no-win64-workaround.patch

    ] ++ optionals (x11Support && stdenv.isDarwin) [
      ./use-correct-tcl-tk-on-darwin.patch
    ] ++ optionals stdenv.isLinux [

      # Disable the use of ldconfig in ctypes.util.find_library (since
      # ldconfig doesn't work on NixOS), and don't use
      # ctypes.util.find_library during the loading of the uuid module
      # (since it will do a futile invocation of gcc (!) to find
      # libuuid, slowing down program startup a lot).
      ./no-ldconfig.patch

      # Fix ctypes.util.find_library with gcc10.
      ./find_library-gcc10.patch

    ] ++ optionals stdenv.hostPlatform.isCygwin [
      ./2.5.2-ctypes-util-find_library.patch
      ./2.5.2-tkinter-x11.patch
      ./2.6.2-ssl-threads.patch
      ./2.6.5-export-PySignal_SetWakeupFd.patch
      ./2.6.5-FD_SETSIZE.patch
      ./2.6.5-ncurses-abi6.patch
      ./2.7.3-dbm.patch
      ./2.7.3-dylib.patch
      ./2.7.3-getpath-exe-extension.patch
      ./2.7.3-no-libm.patch
    ] ++ optionals hasDistutilsCxxPatch [

      # Patch from http://bugs.python.org/issue1222585 adapted to work with
      # `patch -p1' and with a last hunk removed
      # Upstream distutils is calling C compiler to compile C++ code, which
      # only works for GCC and Apple Clang. This makes distutils to call C++
      # compiler when needed.
      ./python-2.7-distutils-C++.patch
    ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      ./cross-compile.patch
    ];

  preConfigure = ''
      # Purity.
      for i in /usr /sw /opt /pkg; do
        substituteInPlace ./setup.py --replace $i /no-such-path
      done
    '' + optionalString (stdenv ? cc && stdenv.cc.libc != null) ''
      for i in Lib/plat-*/regen; do
        substituteInPlace $i --replace /usr/include/ ${stdenv.cc.libc}/include/
      done
    '' + optionalString stdenv.isDarwin ''
      substituteInPlace configure --replace '`/usr/bin/arch`' '"i386"'
      substituteInPlace Lib/multiprocessing/__init__.py \
        --replace 'os.popen(comm)' 'os.popen("${coreutils}/bin/nproc")'
    '';

  configureFlags = optionals enableOptimizations [
    "--enable-optimizations"
  ] ++ optionals (!static) [
    "--enable-shared"
  ] ++ [
    "--with-threads"
    "--with-system-ffi"
    "--with-system-expat"
    "--enable-unicode=ucs${toString ucsEncoding}"
  ] ++ optionals stdenv.hostPlatform.isCygwin [
    "ac_cv_func_bind_textdomain_codeset=yes"
  ] ++ optionals stdenv.isDarwin [
    "--disable-toolbox-glue"
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "PYTHON_FOR_BUILD=${getBin buildPackages.python}/bin/python"
    "ac_cv_buggy_getaddrinfo=no"
    # Assume little-endian IEEE 754 floating point when cross compiling
    "ac_cv_little_endian_double=yes"
    "ac_cv_big_endian_double=no"
    "ac_cv_mixed_endian_double=no"
    "ac_cv_x87_double_rounding=yes"
    "ac_cv_tanh_preserves_zero_sign=yes"
    # Generally assume that things are present and work
    "ac_cv_posix_semaphores_enabled=yes"
    "ac_cv_broken_sem_getvalue=no"
    "ac_cv_wchar_t_signed=yes"
    "ac_cv_rshift_extends_sign=yes"
    "ac_cv_broken_nice=no"
    "ac_cv_broken_poll=no"
    "ac_cv_working_tzset=yes"
    "ac_cv_have_long_long_format=yes"
    "ac_cv_have_size_t_format=yes"
    "ac_cv_computed_gotos=yes"
    "ac_cv_file__dev_ptmx=yes"
    "ac_cv_file__dev_ptc=yes"
  ]
    # Never even try to use lchmod on linux,
    # don't rely on detecting glibc-isms.
  ++ optional stdenv.hostPlatform.isLinux "ac_cv_func_lchmod=no"
  ++ optional static "LDFLAGS=-static";

  strictDeps = true;
  buildInputs =
    optional (stdenv ? cc && stdenv.cc.libc != null) stdenv.cc.libc ++
    [ bzip2 openssl zlib libffi expat db gdbm ncurses sqlite readline ]
    ++ optionals x11Support [ tcl tk libX11 ]
    ++ optional (stdenv.isDarwin && configd != null) configd;
  nativeBuildInputs =
    [ autoreconfHook ]
    ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform)
      [ buildPackages.stdenv.cc buildPackages.python ];

  mkPaths = paths: {
    C_INCLUDE_PATH = makeSearchPathOutput "dev" "include" paths;
    LIBRARY_PATH = makeLibraryPath paths;
  };

  # Python 2.7 needs this
  crossCompileEnv = lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform)
                      { _PYTHON_HOST_PLATFORM = stdenv.hostPlatform.config; };

  # Build the basic Python interpreter without modules that have
  # external dependencies.

in with passthru; stdenv.mkDerivation ({
    pname = "python";
    inherit version;

    inherit src patches buildInputs nativeBuildInputs preConfigure configureFlags;

    LDFLAGS = lib.optionalString (!stdenv.isDarwin) "-lgcc_s";
    inherit (mkPaths buildInputs) C_INCLUDE_PATH LIBRARY_PATH;

    NIX_CFLAGS_COMPILE = optionalString (stdenv.targetPlatform.system == "x86_64-darwin") "-msse2"
      + optionalString stdenv.hostPlatform.isMusl " -DTHREAD_STACK_SIZE=0x100000";
    DETERMINISTIC_BUILD = 1;

    setupHook = python-setup-hook sitePackages;

    postPatch = optionalString (x11Support && (tix != null)) ''
          substituteInPlace "Lib/lib-tk/Tix.py" --replace "os.environ.get('TIX_LIBRARY')" "os.environ.get('TIX_LIBRARY') or '${tix}/lib'"
    '';

    postInstall =
      ''
        # needed for some packages, especially packages that backport
        # functionality to 2.x from 3.x
        for item in $out/lib/${libPrefix}/test/*; do
          if [[ "$item" != */test_support.py*
             && "$item" != */test/support
             && "$item" != */test/regrtest.py* ]]; then
            rm -rf "$item"
          else
            echo $item
          fi
        done
        touch $out/lib/${libPrefix}/test/__init__.py
        ln -s $out/lib/${libPrefix}/pdb.py $out/bin/pdb
        ln -s $out/lib/${libPrefix}/pdb.py $out/bin/pdb${sourceVersion.major}.${sourceVersion.minor}
        ln -s $out/share/man/man1/{python2.7.1.gz,python.1.gz}

        rm "$out"/lib/python*/plat-*/regen # refers to glibc.dev

        # Determinism: Windows installers were not deterministic.
        # We're also not interested in building Windows installers.
        find "$out" -name 'wininst*.exe' | xargs -r rm -f
      '' + optionalString stripBytecode ''
        # Determinism: deterministic bytecode
        # First we delete all old bytecode.
        find $out -name "*.pyc" -delete
        '' + optionalString rebuildBytecode ''
        # We build 3 levels of optimized bytecode. Note the default level, without optimizations,
        # is not reproducible yet. https://bugs.python.org/issue29708
        # Not creating bytecode will result in a large performance loss however, so we do build it.
        find $out -name "*.py" | ${pythonForBuildInterpreter} -m compileall -q -f -x "lib2to3" -i -
        find $out -name "*.py" | ${pythonForBuildInterpreter} -O  -m compileall -q -f -x "lib2to3" -i -
        find $out -name "*.py" | ${pythonForBuildInterpreter} -OO -m compileall -q -f -x "lib2to3" -i -
      '' + optionalString stdenv.hostPlatform.isCygwin ''
        cp libpython2.7.dll.a $out/lib
      '';

    inherit passthru;

    postFixup = ''
      # Include a sitecustomize.py file. Note it causes an error when it's in postInstall with 2.7.
      cp ${../../sitecustomize.py} $out/${sitePackages}/sitecustomize.py
    '' + optionalString strip2to3 ''
      rm -R $out/bin/2to3 $out/lib/python*/lib2to3
    '' + optionalString stripConfig ''
      rm -R $out/bin/python*-config $out/lib/python*/config*
    '' + optionalString stripIdlelib ''
      # Strip IDLE
      rm -R $out/bin/idle* $out/lib/python*/idlelib
    '' + optionalString stripTests ''
      # Strip tests
      rm -R $out/lib/python*/test $out/lib/python*/**/test{,s}
    '' + (concatStringsSep "\n"
          (map
            (lib:
              ''
                rm -vR $out/lib/python*/${lib}
                # libraries in dynload (C libraries) may not exist,
                # but when they exist they may be prefixed with _
                rm -vfR $out/lib/python*/lib-dynload/{,_}${lib}
              '') stripLibs));

    enableParallelBuilding = true;

    doCheck = false; # expensive, and fails

    meta = {
      homepage = "http://python.org";
      description = "A high-level dynamically-typed programming language";
      longDescription = ''
        Python is a remarkably powerful dynamic programming language that
        is used in a wide variety of application domains. Some of its key
        distinguishing features include: clear, readable syntax; strong
        introspection capabilities; intuitive object orientation; natural
        expression of procedural code; full modularity, supporting
        hierarchical packages; exception-based error handling; and very
        high level dynamic data types.
      '';
      license = lib.licenses.psfl;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ fridh thiagokokada ];
      knownVulnerabilities = [
        "Python 2.7 has reached its end of life after 2020-01-01. See https://www.python.org/doc/sunset-python-2/."
        # Quote: That means that we will not improve it anymore after that day,
        # even if someone finds a security problem in it. You should upgrade to
        # Python 3 as soon as you can. [..] So, in 2008, we announced that we
        # would sunset Python 2 in 2015, and asked people to upgrade before
        # then. Some did, but many did not. So, in 2014, we extended that
        # sunset till 2020.
      ];
    };
  } // crossCompileEnv)
