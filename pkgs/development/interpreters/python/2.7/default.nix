{ stdenv, fetchurl, self, callPackage
, bzip2, openssl, gettext

, includeModules ? false

, db, gdbm, ncurses, sqlite, readline

, tcl ? null, tk ? null, xlibsWrapper ? null, libX11 ? null, x11Support ? !stdenv.isCygwin
, zlib ? null, zlibSupport ? true
, expat, libffi

, CF, configd
}:

assert zlibSupport -> zlib != null;
assert x11Support -> tcl != null
                  && tk != null
                  && xlibsWrapper != null
                  && libX11 != null;

with stdenv.lib;

let
  majorVersion = "2.7";
  version = "${majorVersion}.11";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
    sha256 = "0iiz844riiznsyhhyy962710pz228gmhv8qi3yk4w4jhmx2lqawn";
  };

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

      ./properly-detect-curses.patch
    ] ++ optionals stdenv.isCygwin [
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
        --replace 'os.popen(comm)' 'os.popen("nproc")'
    '';

  configureFlags = [
    "--enable-shared"
    "--with-threads"
    "--enable-unicode=ucs4"
  ] ++ optionals stdenv.isCygwin [
    "--with-system-ffi"
    "--with-system-expat"
    "ac_cv_func_bind_textdomain_codeset=yes"
  ] ++ optionals stdenv.isDarwin [
    "--disable-toolbox-glue"
  ];

  postConfigure = if stdenv.isCygwin then ''
    sed -i Makefile -e 's,PYTHONPATH="$(srcdir),PYTHONPATH="$(abs_srcdir),'
  '' else null;

  buildInputs =
    optional (stdenv ? cc && stdenv.cc.libc != null) stdenv.cc.libc ++
    [ bzip2 openssl ]
    ++ optionals stdenv.isCygwin [ expat libffi ]
    ++ optionals includeModules (
        [ db gdbm ncurses sqlite readline
        ] ++ optionals x11Support [ tcl tk xlibsWrapper libX11 ]
    )
    ++ optional zlibSupport zlib
    ++ optional stdenv.isDarwin CF;

  propagatedBuildInputs = optional stdenv.isDarwin configd;

  mkPaths = paths: {
    C_INCLUDE_PATH = makeSearchPathOutput "dev" "include" paths;
    LIBRARY_PATH = makeLibraryPath paths;
  };

  # Build the basic Python interpreter without modules that have
  # external dependencies.
  python = stdenv.mkDerivation {
    name = "python-${version}";
    pythonVersion = majorVersion;

    inherit majorVersion version src patches buildInputs propagatedBuildInputs
            preConfigure configureFlags;

    LDFLAGS = stdenv.lib.optionalString (!stdenv.isDarwin) "-lgcc_s";
    inherit (mkPaths buildInputs) C_INCLUDE_PATH LIBRARY_PATH;

    NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin "-msse2";
    DETERMINISTIC_BUILD = 1;

    setupHook = ./setup-hook.sh;

    postInstall =
      ''
        # needed for some packages, especially packages that backport
        # functionality to 2.x from 3.x
        for item in $out/lib/python${majorVersion}/test/*; do
          if [[ "$item" != */test_support.py* ]]; then
            rm -rf "$item"
          else
            echo $item
          fi
        done
        touch $out/lib/python${majorVersion}/test/__init__.py
        ln -s $out/lib/python${majorVersion}/pdb.py $out/bin/pdb
        ln -s $out/lib/python${majorVersion}/pdb.py $out/bin/pdb${majorVersion}
        ln -s $out/share/man/man1/{python2.7.1.gz,python.1.gz}

        paxmark E $out/bin/python${majorVersion}

        ${optionalString includeModules "$out/bin/python ./setup.py build_ext"}

        rm "$out"/lib/python*/plat-*/regen # refers to glibc.dev
      '';

    passthru = rec {
      inherit zlibSupport;
      isPy2 = true;
      isPy27 = true;
      buildEnv = callPackage ../wrapper.nix { python = self; };
      libPrefix = "python${majorVersion}";
      executable = libPrefix;
      sitePackages = "lib/${libPrefix}/site-packages";
      interpreter = "${self}/bin/${executable}";
    };

    enableParallelBuilding = true;

    meta = {
      homepage = "http://python.org";
      description = "a high-level dynamically-typed programming language";
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
      maintainers = with stdenv.lib.maintainers; [ chaoflow iElectric ];
    };
  };


  # This function builds a Python module included in the main Python
  # distribution in a separate derivation.
  buildInternalPythonModule =
    { moduleName
    , internalName ? "_" + moduleName
    , deps
    }:
    if includeModules then null else stdenv.mkDerivation rec {
      name = "python-${moduleName}-${python.version}";

      inherit src patches preConfigure postConfigure configureFlags;

      buildInputs = [ python ] ++ deps;

      inherit (mkPaths buildInputs) C_INCLUDE_PATH LIBRARY_PATH;

      # non-python gdbm has a libintl dependency on i686-cygwin, not on x86_64-cygwin
      buildPhase = (if (stdenv.system == "i686-cygwin" && moduleName == "gdbm") then ''
          sed -i setup.py -e "s:libraries = \['gdbm'\]:libraries = ['gdbm', 'intl']:"
      '' else '''') + ''
          substituteInPlace setup.py --replace 'self.extensions = extensions' \
            'self.extensions = [ext for ext in self.extensions if ext.name in ["${internalName}"]]'

          python ./setup.py build_ext
          [ -z "$(find build -name '*_failed.so' -print)" ]
        '';

      installPhase =
        ''
          dest=$out/lib/${python.libPrefix}/site-packages
          mkdir -p $dest
          cp -p $(find . -name "*.${if stdenv.isCygwin then "dll" else "so"}") $dest/
        '';
    };


  # The Python modules included in the main Python distribution, built
  # as separate derivations.
  modules = {

    bsddb = buildInternalPythonModule {
      moduleName = "bsddb";
      deps = [ db ];
    };

    curses = buildInternalPythonModule {
      moduleName = "curses";
      deps = [ ncurses ];
    };

    curses_panel = buildInternalPythonModule {
      moduleName = "curses_panel";
      deps = [ ncurses modules.curses ];
    };

    crypt = buildInternalPythonModule {
      moduleName = "crypt";
      internalName = "crypt";
      deps = optional (stdenv ? glibc) stdenv.glibc;
    };

    gdbm = buildInternalPythonModule {
      moduleName = "gdbm";
      internalName = "gdbm";
      deps = [ gdbm ] ++ stdenv.lib.optional stdenv.isCygwin gettext;
    };

    sqlite3 = buildInternalPythonModule {
      moduleName = "sqlite3";
      deps = [ sqlite ];
    };

  } // optionalAttrs x11Support {

    tkinter = if stdenv.isCygwin then null else (buildInternalPythonModule {
      moduleName = "tkinter";
      deps = [ tcl tk xlibsWrapper libX11 ];
    });

  } // {

    readline = buildInternalPythonModule {
      moduleName = "readline";
      internalName = "readline";
      deps = [ readline ];
    };

  };

in python // { inherit modules; }
