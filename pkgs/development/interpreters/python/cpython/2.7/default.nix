{ stdenv, fetchurl, fetchpatch
, bzip2
, expat
, libffi
, gdbm
, db
, ncurses
, openssl
, readline
, sqlite
, tcl ? null, tk ? null, tix ? null, xlibsWrapper ? null, libX11 ? null, x11Support ? false
, zlib
, self
, configd, coreutils
, python-setup-hook
# Some proprietary libs assume UCS2 unicode, especially on darwin :(
, ucsEncoding ? 4
# For the Python package set
, packageOverrides ? (self: super: {})
, buildPackages
, sourceVersion
, sha256
, passthruFun
, static ? false
}:

assert x11Support -> tcl != null
                  && tk != null
                  && xlibsWrapper != null
                  && libX11 != null;

with stdenv.lib;

let

  pythonForBuild = buildPackages.${"python${sourceVersion.major}${sourceVersion.minor}"};

  passthru = passthruFun rec {
    inherit self sourceVersion packageOverrides;
    implementation = "cpython";
    libPrefix = "python${pythonVersion}";
    executable = libPrefix;
    pythonVersion = with sourceVersion; "${major}.${minor}";
    sitePackages = "lib/${libPrefix}/site-packages";
    inherit hasDistutilsCxxPatch pythonForBuild;
  } // {
    inherit ucsEncoding;
  };

  version = with sourceVersion; "${major}.${minor}.${patch}${suffix}";

  src = fetchurl {
    url = with sourceVersion; "https://www.python.org/ftp/python/${major}.${minor}.${patch}/Python-${version}.tar.xz";
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
    ] ++ optionals (x11Support && stdenv.isDarwin) [
      ./use-correct-tcl-tk-on-darwin.patch
    ] ++ optionals stdenv.isLinux [

      # Disable the use of ldconfig in ctypes.util.find_library (since
      # ldconfig doesn't work on NixOS), and don't use
      # ctypes.util.find_library during the loading of the uuid module
      # (since it will do a futile invocation of gcc (!) to find
      # libuuid, slowing down program startup a lot).
      ./no-ldconfig.patch

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
    ] ++ optional (stdenv.hostPlatform != stdenv.buildPlatform) [
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

  configureFlags = [
    "--enable-shared"
    "--with-threads"
    "--enable-unicode=ucs${toString ucsEncoding}"
  ] ++ optionals (stdenv.hostPlatform.isCygwin || stdenv.hostPlatform.isAarch64) [
    "--with-system-ffi"
  ] ++ optionals stdenv.hostPlatform.isCygwin [
    "--with-system-expat"
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

  buildInputs =
    optional (stdenv ? cc && stdenv.cc.libc != null) stdenv.cc.libc ++
    [ bzip2 openssl zlib ]
    ++ optional (stdenv.hostPlatform.isCygwin || stdenv.hostPlatform.isAarch64) libffi
    ++ optional stdenv.hostPlatform.isCygwin expat
    ++ [ db gdbm ncurses sqlite readline ]
    ++ optionals x11Support [ tcl tk xlibsWrapper libX11 ]
    ++ optional (stdenv.isDarwin && configd != null) configd;
  nativeBuildInputs =
    optionals (stdenv.hostPlatform != stdenv.buildPlatform)
    [ buildPackages.stdenv.cc buildPackages.python ];

  mkPaths = paths: {
    C_INCLUDE_PATH = makeSearchPathOutput "dev" "include" paths;
    LIBRARY_PATH = makeLibraryPath paths;
  };

  # Python 2.7 needs this
  crossCompileEnv = stdenv.lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform)
                      { _PYTHON_HOST_PLATFORM = stdenv.hostPlatform.config; };

  # Build the basic Python interpreter without modules that have
  # external dependencies.

in with passthru; stdenv.mkDerivation ({
    pname = "python";
    inherit version;

    inherit src patches buildInputs nativeBuildInputs preConfigure configureFlags;

    LDFLAGS = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";
    inherit (mkPaths buildInputs) C_INCLUDE_PATH LIBRARY_PATH;

    NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin "-msse2"
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
      '' + optionalString (stdenv.hostPlatform == stdenv.buildPlatform)
      ''
        # Determinism: rebuild all bytecode
        # We exclude lib2to3 because that's Python 2 code which fails
        # We rebuild three times, once for each optimization level
        find $out -name "*.py" | $out/bin/python -m compileall -q -f -x "lib2to3" -i -
        find $out -name "*.py" | $out/bin/python -O -m compileall -q -f -x "lib2to3" -i -
        find $out -name "*.py" | $out/bin/python -OO -m compileall -q -f -x "lib2to3" -i -
      '' + optionalString stdenv.hostPlatform.isCygwin ''
        cp libpython2.7.dll.a $out/lib
      '';

    inherit passthru;

    postFixup = ''
      # Include a sitecustomize.py file. Note it causes an error when it's in postInstall with 2.7.
      cp ${../../sitecustomize.py} $out/${sitePackages}/sitecustomize.py
    '';

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
      license = stdenv.lib.licenses.psfl;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers; [ fridh ];
      # Higher priority than Python 3.x so that `/bin/python` points to `/bin/python2`
      # in case both 2 and 3 are installed.
      priority = -100;
    };
  } // crossCompileEnv)
