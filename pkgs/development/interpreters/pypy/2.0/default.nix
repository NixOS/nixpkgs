{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, pythonFull }:

assert zlibSupport -> zlib != null;

let

  majorVersion = "2.0";
  version = "${majorVersion}.2";

  src = fetchurl {
    url = "https://bitbucket.org/pypy/pypy/downloads/pypy-${version}-src.tar.bz2";
    sha256 = "0g2cajs6m3yf0lak5f18ccs6j77cf5xvbm4h6y5l1qlqdc6wk48r";
  };

  #patches =
  #  [ # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
  #    ./search-path.patch

      # Python recompiles a Python if the mtime stored *in* the
      # pyc/pyo file differs from the mtime of the source file.  This
      # doesn't work in Nix because Nix changes the mtime of files in
      # the Nix store to 1.  So treat that as a special case.
  #    ./nix-store-mtime.patch

      # patch python to put zero timestamp into pyc
      # if DETERMINISTIC_BUILD env var is set
  #    ./deterministic-build.patch
  #  ];
  #'';

  install = ''
    cd ./pypy/pypy/tool/release/
    ${pythonFull}/bin/python package.py ../../.. pypy-my-own-package-name
  '';

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [ bzip2 openssl pkgconfig pythonFull libffi ncurses ]
    ++ optional zlibSupport zlib;

  pypy = stdenv.mkDerivation rec {
    name = "pypy-${version}";

    inherit majorVersion version src buildInputs;

    C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
    LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);

    preConfigure = ''
      substituteInPlace Makefile \
        --replace "-Ojit" "-Ojit --batch" \
        --replace "pypy/goal/targetpypystandalone.py" "pypy/goal/targetpypystandalone.py --withmod-_minimal_curses"

      # we are using cpython and not pypy to do translation
      substituteInPlace rpython/bin/rpython \
        --replace "/usr/bin/env pypy" "${pythonFull}/bin/python"
      substituteInPlace pypy/goal/targetpypystandalone.py \
        --replace "/usr/bin/env pypy" "${pythonFull}/bin/python"

      # convince pypy to find nix ncurses
      substituteInPlace pypy/module/_minimal_curses/fficurses.py \
        --replace "/usr/include/ncurses/curses.h" "${ncurses}/include/curses.h" \
        --replace "ncurses/curses.h" "${ncurses}/include/curses.h" \
        --replace "ncurses/term.h" "${ncurses}/include/term.h" \
        --replace "libraries = ['curses']" "libraries = ['ncurses']"

      #substituteInPlace rpython/translator/platform/__init__.py \
      #  --replace "return include_dirs" "return tuple(\"{expat}\", *include_dirs)" \
      #  --replace "return library_dirs" "return tuple(\"{expat}\", *library_dirs)"
    '';

    passthru = {
      inherit zlibSupport;
      libPrefix = "pypy${majorVersion}";
    };

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = "http://pypy.org/";
      description = "PyPy is a fast, compliant alternative implementation of the Python language (2.7.3)";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = with maintainers; [ iElectric ];
    };
  };

in pypy // { inherit modules; }
