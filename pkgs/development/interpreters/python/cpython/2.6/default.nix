{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2, includeModules ? false
, sqlite, tcl, tk, xlibsWrapper, openssl, readline, db, ncurses, gdbm, self, callPackage
, python26Packages }:

assert zlibSupport -> zlib != null;

with stdenv.lib;

let
  majorVersion = "2.6";
  version = "${majorVersion}.9";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
    sha256 = "0hbfs2691b60c7arbysbzr0w9528d5pl8a4x7mq5psh6a2cvprya";
  };

  patches =
    [ # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
      ./search-path.patch

      # Python recompiles a Python if the mtime stored *in* the
      # pyc/pyo file differs from the mtime of the source file.  This
      # doesn't work in Nix because Nix changes the mtime of files in
      # the Nix store to 1.  So treat that as a special case.
      ./nix-store-mtime.patch

      # http://bugs.python.org/issue10013
      ./python2.6-fix-parallel-make.patch
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
    '' + optionalString stdenv.isCygwin ''
      # On Cygwin, `make install' tries to read this Makefile.
      mkdir -p $out/lib/python${majorVersion}/config
      touch $out/lib/python${majorVersion}/config/Makefile
      mkdir -p $out/include/python${majorVersion}
      touch $out/include/python${majorVersion}/pyconfig.h
    '';

  configureFlags = "--enable-shared --with-threads --enable-unicode=ucs4";

  buildInputs =
    optional (stdenv ? cc && stdenv.cc.libc != null) stdenv.cc.libc ++
    [ bzip2 openssl ]++ optionals includeModules [ db openssl ncurses gdbm readline xlibsWrapper tcl tk sqlite ]
    ++ optional zlibSupport zlib;

  mkPaths = paths: {
    C_INCLUDE_PATH = makeSearchPathOutput "dev" "include" paths;
    LIBRARY_PATH = makeLibraryPath paths;
  };

  # Build the basic Python interpreter without modules that have
  # external dependencies.
  python = stdenv.mkDerivation {
    name = "python${if includeModules then "" else "-minimal"}-${version}";
    pythonVersion = majorVersion;

    inherit majorVersion version src patches buildInputs preConfigure
            configureFlags;

    inherit (mkPaths buildInputs) C_INCLUDE_PATH LIBRARY_PATH;

    NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin "-msse2";

    setupHook = ./setup-hook.sh;

    postInstall =
      ''
        # needed for some packages, especially packages that backport
        # functionality to 2.x from 3.x
        for item in $out/lib/python${majorVersion}/test/*; do
          if [[ "$item" != */test_support.py* ]]; then
            rm -rf "$item"
          fi
        done
        touch $out/lib/python${majorVersion}/test/__init__.py
        ln -s $out/lib/python${majorVersion}/pdb.py $out/bin/pdb
        ln -s $out/lib/python${majorVersion}/pdb.py $out/bin/pdb${majorVersion}
        mv $out/share/man/man1/{python.1,python2.6.1}
        ln -s $out/share/man/man1/{python2.6.1,python.1}

        paxmark E $out/bin/python${majorVersion}

        ${ optionalString includeModules "$out/bin/python ./setup.py build_ext"}
      '';

    passthru = rec {
      inherit zlibSupport;
      isPy2 = true;
      isPy26 = true;
      buildEnv = callPackage ../../wrapper.nix { python = self; };
      withPackages = import ../../with-packages.nix { inherit buildEnv; pythonPackages = python26Packages; };
      libPrefix = "python${majorVersion}";
      executable = libPrefix;
      sitePackages = "lib/${libPrefix}/site-packages";
      interpreter = "${self}/bin/${executable}";
    };

    enableParallelBuilding = true;

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
      maintainers = with stdenv.lib.maintainers; [ chaoflow domenkozar ];
      # If you want to use Python 2.6, remove "broken = true;" at your own
      # risk.  Python 2.6 has known security vulnerabilities is not receiving
      # security updates as of October 2013.
      broken = true;
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

      inherit src patches preConfigure configureFlags;

      buildInputs = [ python ] ++ deps;

      inherit (mkPaths buildInputs) C_INCLUDE_PATH LIBRARY_PATH;

      buildPhase =
        ''
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

    crypt = buildInternalPythonModule {
      moduleName = "crypt";
      internalName = "crypt";
      deps = optional (stdenv ? glibc) stdenv.glibc;
    };

    curses = buildInternalPythonModule {
      moduleName = "curses";
      deps = [ ncurses ];
    };

    curses_panel = buildInternalPythonModule {
      moduleName = "curses_panel";
      deps = [ ncurses modules.curses ];
    };

    gdbm = buildInternalPythonModule {
      moduleName = "gdbm";
      internalName = "gdbm";
      deps = [ gdbm ];
    };

    sqlite3 = buildInternalPythonModule {
      moduleName = "sqlite3";
      deps = [ sqlite ];
    };

    tkinter = buildInternalPythonModule {
      moduleName = "tkinter";
      deps = [ tcl tk xlibsWrapper ];
    };

    readline = buildInternalPythonModule {
      moduleName = "readline";
      internalName = "readline";
      deps = [ readline ];
    };

  };

in python // { inherit modules; }
