{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2
, sqlite, tcl, tk, x11, openssl, readline, db, ncurses, gdbm, libX11 }:

assert zlibSupport -> zlib != null;

with stdenv.lib;

let

  majorVersion = "2.7";
  version = "${majorVersion}.7";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
    sha256 = "0y6s12rdi89k24p8zarhy9fqmyy459yg0d125c7cac4v136y70r9";
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
    ];

  postPatch = stdenv.lib.optionalString (stdenv.gcc.libc != null) ''
    substituteInPlace ./Lib/plat-generic/regen \
                      --replace /usr/include/netinet/in.h \
                                ${stdenv.gcc.libc}/include/netinet/in.h
  '';

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [ bzip2 openssl ]
    ++ optional zlibSupport zlib;

  ensurePurity =
    ''
      # Purity.
      for i in /usr /sw /opt /pkg; do
        substituteInPlace ./setup.py --replace $i /no-such-path
      done
    '';

  # Build the basic Python interpreter without modules that have
  # external dependencies.
  python = stdenv.mkDerivation {
    name = "python-${version}";

    inherit majorVersion version src patches postPatch buildInputs;

    C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
    LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);

    configureFlags = "--enable-shared --with-threads --enable-unicode";

    preConfigure = "${ensurePurity}" + optionalString stdenv.isCygwin
      ''
        # On Cygwin, `make install' tries to read this Makefile.
        mkdir -p $out/lib/python${majorVersion}/config
        touch $out/lib/python${majorVersion}/config/Makefile
        mkdir -p $out/include/python${majorVersion}
        touch $out/include/python${majorVersion}/pyconfig.h
      '';

    NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin "-msse2";

    setupHook = ./setup-hook.sh;

    postInstall =
      ''
        rm -rf "$out/lib/python${majorVersion}/test"
        ln -s $out/lib/python${majorVersion}/pdb.py $out/bin/pdb
        ln -s $out/lib/python${majorVersion}/pdb.py $out/bin/pdb${majorVersion}
        ln -s $out/share/man/man1/{python2.7.1.gz,python.1.gz}
      '';

    passthru = {
      inherit zlibSupport;
      libPrefix = "python${majorVersion}";
      executable = "python2.7";
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
      maintainers = with stdenv.lib.maintainers; [ simons chaoflow ];
    };
  };


  # This function builds a Python module included in the main Python
  # distribution in a separate derivation.
  buildInternalPythonModule =
    { moduleName
    , internalName ? "_" + moduleName
    , deps
    }:
    stdenv.mkDerivation rec {
      name = "python-${moduleName}-${python.version}";

      inherit src patches postPatch;

      buildInputs = [ python ] ++ deps;

      C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
      LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);

      configurePhase = "${ensurePurity}";

      buildPhase =
        ''
          # Fake the build environment that setup.py expects.
          ln -s ${python}/include/python*/pyconfig.h .
          ln -s ${python}/lib/python*/config/Setup Modules/
          ln -s ${python}/lib/python*/config/Setup.local Modules/

          substituteInPlace setup.py --replace 'self.extensions = extensions' \
            'self.extensions = [ext for ext in self.extensions if ext.name in ["${internalName}"]]'

          python ./setup.py build_ext
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
      deps = [ ];
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

    ssl = null;

    tkinter = buildInternalPythonModule {
      moduleName = "tkinter";
      deps = [ tcl tk x11 libX11 ];
    };

    readline = buildInternalPythonModule {
      moduleName = "readline";
      internalName = "readline";
      deps = [ readline ];
    };

  };

in python // { inherit modules; }
